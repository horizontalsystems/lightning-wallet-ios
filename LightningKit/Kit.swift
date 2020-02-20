import Foundation
import GRPC
import RxSwift

public class Kit {
    private let lndNode: ILndNode
    private let paymentsUpdatedSubject = PublishSubject<Void>()

    public var statusObservable: Observable<NodeStatus> {
        lndNode.statusObservable
    }
    public var invoicesObservable: Observable<Lnrpc_Invoice> {
        retryWhenStatusIsSyncingOrRunning(lndNode.invoicesObservable)
    }
    public var paymentsObservable: Observable<Void> {
        paymentsUpdatedSubject.asObservable()
    }
    public var channelsObservable: Observable<Lnrpc_ChannelEventUpdate> {
        retryWhenStatusIsSyncingOrRunning(lndNode.channelsObservable)
    }
    public var transactionsObservable: Observable<Lnrpc_Transaction> {
        retryWhenStatusIsSyncingOrRunning(lndNode.transactionsObservable)
    }
    public var walletBalanceObservable: Observable<Lnrpc_WalletBalanceResponse> {
        transactionsObservable.flatMap { [weak self] _ in
            self?.walletBalanceSingle.asObservable() ?? Observable.empty()
        }
    }
    public var channelBalanceObservable: Observable<Lnrpc_ChannelBalanceResponse> {
        Observable
            .merge([
                paymentsObservable,
                invoicesObservable.filter { $0.state == .settled }.map { _ in Void() }
            ])
            .flatMap { [weak self] _ in
                self?.channelBalanceSingle.asObservable() ?? Observable.empty()
            }
    }
    
    fileprivate init(lndNode: ILndNode) {
        self.lndNode = lndNode
    }
    
    public var walletBalanceSingle: Single<Lnrpc_WalletBalanceResponse> {
        lndNode.walletBalanceSingle
    }

    public var channelBalanceSingle: Single<Lnrpc_ChannelBalanceResponse> {
        lndNode.channelBalanceSingle
    }

    public var onChainAddressSingle: Single<Lnrpc_NewAddressResponse> {
        lndNode.onChainAddressSingle
    }

    public var channelsSingle: Single<Lnrpc_ListChannelsResponse> {
        lndNode.channelsSingle
    }

    public var closedChannelsSingle: Single<Lnrpc_ClosedChannelsResponse> {
        lndNode.closedChannelsSingle
    }

    public var pendingChannelsSingle: Single<Lnrpc_PendingChannelsResponse> {
        lndNode.pendingChannelsSingle
    }
    
    public var paymentsSingle: Single<Lnrpc_ListPaymentsResponse> {
        lndNode.paymentsSingle
    }

    public func invoicesSingle(pending_only: Bool = false, offset: UInt64 = 0, limit: UInt64 = 1000, reversed: Bool = false) -> Single<Lnrpc_ListInvoiceResponse> {
        lndNode.invoicesSingle(pendingOnly: pending_only, offset: offset, limit: limit, reversed: reversed)
    }
    
    public func paySingle(invoice: String) -> Single<Lnrpc_SendResponse> {
        return lndNode.paySingle(invoice: invoice)
            .do(onSuccess: { [weak self] in
                if $0.paymentError.isEmpty {
                    self?.paymentsUpdatedSubject.onNext(Void())
                }
            })
    }

    public func addInvoiceSingle(amount: Int64, memo: String) -> Single<Lnrpc_AddInvoiceResponse> {
        lndNode.addInvoiceSingle(amount: amount, memo: memo)
    }

    public func unlockWalletSingle(password: Data) -> Single<Void> {
        lndNode.unlockWalletSingle(password: password)
    }
    
    public func decodeSingle(paymentRequest: String) -> Single<Lnrpc_PayReq> {
        lndNode.decodeSingle(paymentRequest: paymentRequest)
    }

    public func openChannelSingle(nodePubKey: Data, amount: Int64, nodeAddress: String) -> Observable<Lnrpc_OpenStatusUpdate> {
        lndNode.connectSingle(nodeAddress: nodeAddress, nodePubKey: nodePubKey.hex)
            .map { _ in Void() }
            .catchError { error -> Single<Void> in
                if let grpcStatus = error as? GRPC.GRPCStatus, let message = grpcStatus.message,
                    message.contains("already connected to peer") {
                    return Single.just(Void())
                } else {
                    return Single.error(error)
                }
            }
            .asObservable()
            .flatMap { [weak self] _ -> Observable<Lnrpc_OpenStatusUpdate> in
                guard let kit = self else {
                    return Observable.empty()
                }
                
                return kit.lndNode.openChannelSingle(nodePubKey: nodePubKey, amount: amount)
            }
    }

    public func closeChannelSingle(channelPoint: String, forceClose: Bool) throws -> Observable<Lnrpc_CloseStatusUpdate> {
        try lndNode.closeChannelSingle(channelPoint: channelPoint, forceClose: forceClose)
    }

    private func retryWhenStatusIsSyncingOrRunning<T>(_ observable: Observable<T>) -> Observable<T> {
        observable.retryWhen { [weak self] errorObservable -> Observable<(Error, NodeStatus)> in
            guard let kit = self else {
                return .empty()
            }
            
            return Observable.zip(errorObservable, kit.statusObservable.filter { $0 == .syncing || $0 == .running })
        }
    }
}

public extension Kit {
    static var lightningKitLocalLnd: Kit? = nil
    
    static func validateRemoteConnection(rpcCredentials: RpcCredentials) -> Single<Void> {
        do {
            let remoteLndNode = try RemoteLnd(rpcCredentials: rpcCredentials)
            
            return remoteLndNode.validateAsync()
        } catch {
            return Single.error(error)
        }
    }

    static func createLocal(credentials: LocalNodeCredentials) -> Single<[String]> {
        let localLnd = LocalLnd(credentials: credentials)
        lightningKitLocalLnd = Kit(lndNode: localLnd)

        return localLnd.start().flatMap { localLnd.createWallet(password: credentials.password) }
    }

    static func remote(rpcCredentials: RpcCredentials) throws -> Kit {
        let remoteLndNode = try RemoteLnd(rpcCredentials: rpcCredentials)
        remoteLndNode.scheduleStatusUpdates()
        
        return Kit(lndNode: remoteLndNode)
    }
}
