import Foundation
import GRPC
import RxSwift

public class Kit {
    public enum KitErrors: Error {
        case wrongChannelPoint
        case cannotInitRemoteNode
    }

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
                    invoicesObservable.filter {
                        $0.state == .settled
                    }.map { _ in
                        Void()
                    }
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
    
    public var transactionsSingle: Single<Lnrpc_TransactionDetails> {
        lndNode.transactionsSingle
    }

    public func invoicesSingle(pendingOnly: Bool = false, offset: UInt64 = 0, limit: UInt64 = 1000, reversed: Bool = false) -> Single<Lnrpc_ListInvoiceResponse> {
        var request = Lnrpc_ListInvoiceRequest()
        request.pendingOnly = pendingOnly
        request.indexOffset = offset
        request.numMaxInvoices = limit
        request.reversed = reversed

        return lndNode.invoicesSingle(request: request)
    }

    public func paySingle(invoice: String) -> Single<Lnrpc_SendResponse> {
        var request = Lnrpc_SendRequest()
        request.paymentRequest = invoice

        return lndNode.paySingle(request: request)
                .do(onSuccess: { [weak self] in
                    if $0.paymentError.isEmpty {
                        self?.paymentsUpdatedSubject.onNext(Void())
                    }
                })
    }

    public func addInvoiceSingle(amount: Int64, memo: String) -> Single<Lnrpc_AddInvoiceResponse> {
        var invoice = Lnrpc_Invoice()
        invoice.value = amount
        invoice.memo = memo

        return lndNode.addInvoiceSingle(invoice: invoice)
    }

    public func unlockWalletSingle(password: Data) -> Single<Void> {
        var request = Lnrpc_UnlockWalletRequest()
        request.walletPassword = password

        return lndNode.unlockWalletSingle(request: request)
    }

    public func decodeSingle(paymentRequest: String) -> Single<Lnrpc_PayReq> {
        var request = Lnrpc_PayReqString()
        request.payReq = paymentRequest

        return lndNode.decodeSingle(paymentRequest: request)
    }

    public func openChannelSingle(nodePubKey: Data, amount: Int64, nodeAddress: String) -> Observable<Lnrpc_OpenStatusUpdate> {
        var openChannelRequest = Lnrpc_OpenChannelRequest()
        openChannelRequest.nodePubkey = nodePubKey
        openChannelRequest.satPerByte = 2 // todo: extract as param
        openChannelRequest.localFundingAmount = amount

        var lightningAddress = Lnrpc_LightningAddress()
        lightningAddress.pubkey = nodePubKey.hex
        lightningAddress.host = nodeAddress

        var connectPeersRequest = Lnrpc_ConnectPeerRequest()
        connectPeersRequest.addr = lightningAddress

        return lndNode.connectSingle(request: connectPeersRequest)
                .map { _ in
                    Void()
                }
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

                    return kit.lndNode.openChannelSingle(request: openChannelRequest)
                }
    }

    public func closeChannelSingle(channelPoint: String, forceClose: Bool) throws -> Observable<Lnrpc_CloseStatusUpdate> {
        let channelPointParts = channelPoint.split(separator: ":")

        guard channelPointParts.count == 0, let outputIndex = UInt32(String(channelPointParts[1])) else {
            throw KitErrors.wrongChannelPoint
        }

        var channelPoint = Lnrpc_ChannelPoint()
        channelPoint.fundingTxidStr = String(channelPointParts[0])
        channelPoint.outputIndex = outputIndex

        var request = Lnrpc_CloseChannelRequest()
        request.channelPoint = channelPoint
        request.satPerByte = 2 // todo: extract as param
        request.force = forceClose

        return try lndNode.closeChannelSingle(request: request)
    }

    // LocalLnd methods

    public func start(password: String) -> Single<Void> {
        guard let localNode = lndNode as? LocalLnd else {
            return Single.just(Void())
        }

        return localNode.startAndUnlock(password: password)
    }

    public func create(password: String) -> Single<[String]> {
        guard let localNode = lndNode as? LocalLnd else {
            return Single.error(KitErrors.cannotInitRemoteNode)
        }

        return localNode.start().flatMap {
            localNode.createWalletSingle(password: password)
        }
    }

    public func restore(words: [String], password: String) -> Single<Void> {
        guard let localNode = lndNode as? LocalLnd else {
            return Single.error(KitErrors.cannotInitRemoteNode)
        }

        return localNode.start().flatMap {
            localNode.restoreWalletSingle(words: words, password: password)
        }
    }

    // Private methods

    private func retryWhenStatusIsSyncingOrRunning<T>(_ observable: Observable<T>) -> Observable<T> {
        observable.retryWhen { [weak self] errorObservable -> Observable<(Error, NodeStatus)> in
            guard let kit = self else {
                return .empty()
            }

            return Observable.zip(errorObservable, kit.statusObservable.filter {
                $0 == .syncing || $0 == .running
            })
        }
    }
}

public extension Kit {
    static func validateRemoteConnection(rpcCredentials: RpcCredentials) -> Single<Void> {
        do {
            let remoteLndNode = try RemoteLnd(rpcCredentials: rpcCredentials)

            return remoteLndNode.validateAsync()
        } catch {
            return Single.error(error)
        }
    }

    static func remote(rpcCredentials: RpcCredentials) throws -> Kit {
        let remoteLndNode = try RemoteLnd(rpcCredentials: rpcCredentials)
        remoteLndNode.scheduleStatusUpdates()

        return Kit(lndNode: remoteLndNode)
    }

    static func local() throws -> Kit {
        let localLnd = LocalLnd(filesDir: try FileManager.default.walletDirectory().path)

        return Kit(lndNode: localLnd)
    }
}
