import Foundation
import GRPC
import RxSwift

public class Kit {
    private let lndNode: ILndNode
    
    public var statusObservable: Observable<NodeStatus> {
        lndNode.statusObservable
    }
    public var paymentsObservable: Observable<Void> {
        paymentsUpdatedSubject.asObservable()
    }
    public var invoicesObservable: Observable<Lnrpc_Invoice> {
        retryWhenStatusIsSyncingOrRunning(lndNode.invoicesObservable())
    }
    public var channelsObservable: Observable<Lnrpc_ChannelEventUpdate> {
        retryWhenStatusIsSyncingOrRunning(lndNode.channelsObservable())
    }

    private let paymentsUpdatedSubject = PublishSubject<Void>()
    
    fileprivate init(lndNode: ILndNode) {
        self.lndNode = lndNode
    }
    
    public func getWalletBalance() -> Single<Lnrpc_WalletBalanceResponse> {
        lndNode.getWalletBalance()
    }

    public func getChannelBalance() -> Single<Lnrpc_ChannelBalanceResponse> {
        lndNode.getChannelBalance()
    }

    public func getOnChainAddress() -> Single<Lnrpc_NewAddressResponse> {
        lndNode.getOnChainAddress()
    }

    public func listChannels() -> Single<Lnrpc_ListChannelsResponse> {
        lndNode.listChannels()
    }

    public func listClosedChannels() -> Single<Lnrpc_ClosedChannelsResponse> {
        lndNode.listClosedChannels()
    }

    public func listPendingChannels() -> Single<Lnrpc_PendingChannelsResponse> {
        lndNode.listPendingChannels()
    }

    public func decodePayReq(req: String) -> Single<Lnrpc_PayReq> {
        lndNode.decodePayReq(req: req)
    }

    public func payInvoice(invoice: String) -> Single<Lnrpc_SendResponse> {
        return lndNode.payInvoice(invoice: invoice)
            .do(onSuccess: { [weak self] in
                if $0.paymentError.isEmpty {
                    self?.paymentsUpdatedSubject.onNext(Void())
                }
            })
    }

    public func addInvoice(amount: Int64, memo: String) -> Single<Lnrpc_AddInvoiceResponse> {
        lndNode.addInvoice(amount: amount, memo: memo)
    }

    public func listPayments() -> Single<Lnrpc_ListPaymentsResponse> {
        lndNode.listPayments()
    }

    public func listInvoices(pending_only: Bool = false, offset: UInt64 = 0, limit: UInt64 = 1000, reversed: Bool = false) -> Single<Lnrpc_ListInvoiceResponse> {
        lndNode.listInvoices(pendingOnly: pending_only, offset: offset, limit: limit, reversed: reversed)
    }

    public func unlockWallet(password: Data) -> Single<Void> {
        lndNode.unlockWallet(password: password)
    }

    public func openChannel(nodePubKey: Data, amount: Int64, nodeAddress: String) -> Observable<Lnrpc_OpenStatusUpdate> {
        lndNode.connect(nodeAddress: nodeAddress, nodePubKey: nodePubKey.hex)
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
                
                return kit.lndNode.openChannel(nodePubKey: nodePubKey, amount: amount)
            }
    }

    public func closeChannel(channelPoint: String, forceClose: Bool) throws -> Observable<Lnrpc_CloseStatusUpdate> {
        try lndNode.closeChannel(channelPoint: channelPoint, forceClose: forceClose)
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
