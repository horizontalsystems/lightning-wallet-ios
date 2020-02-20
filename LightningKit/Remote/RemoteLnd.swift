import Foundation
import GRPC
import NIO
import NIOSSL
import NIOHPACK
import Logging
import RxSwift

class RemoteLnd: ILndNode {
    enum ArgumentError: Error {
        case wrongChannelPoint
    }

    private let connection: LndNioConnection
    private let walletUnlocker: WalletUnlocker
    private let disposeBag = DisposeBag()

    private let statusSubject = BehaviorSubject<NodeStatus>(value: .connecting)
    private(set) var status: NodeStatus = .connecting {
        didSet {
            if status != oldValue {
                statusSubject.onNext(status)
            }
        }
    }

    var statusObservable: Observable<NodeStatus> { statusSubject.asObservable() }

    var invoicesObservable: Observable<Lnrpc_Invoice> {
        connection.serverStreamCall() { client, handler -> ServerStreamingCall<Lnrpc_InvoiceSubscription, Lnrpc_Invoice> in
            let request = Lnrpc_InvoiceSubscription()

            return client.subscribeInvoices(request, handler: handler)
        }
    }

    var channelsObservable: Observable<Lnrpc_ChannelEventUpdate> {
        connection.serverStreamCall() { client, handler -> ServerStreamingCall<Lnrpc_ChannelEventSubscription, Lnrpc_ChannelEventUpdate> in
            let channelEventSubscription = Lnrpc_ChannelEventSubscription()

            return client.subscribeChannelEvents(channelEventSubscription, handler: handler)
        }
    }

    var transactionsObservable: Observable<Lnrpc_Transaction> {
        connection.serverStreamCall() { client, handler -> ServerStreamingCall<Lnrpc_GetTransactionsRequest, Lnrpc_Transaction> in
            let request = Lnrpc_GetTransactionsRequest()
            
            return client.subscribeTransactions(request, handler: handler)
        }
    }

    var infoSingle: Single<Lnrpc_GetInfoResponse> {
        connection.unaryCall() {
            let request = Lnrpc_GetInfoRequest()
            return $0.getInfo(request).response
        }
    }

    var walletBalanceSingle: Single<Lnrpc_WalletBalanceResponse> {
        connection.unaryCall() {
            let request = Lnrpc_WalletBalanceRequest()
            return $0.walletBalance(request).response
        }
    }

    var channelBalanceSingle: Single<Lnrpc_ChannelBalanceResponse> {
        connection.unaryCall() {
            let request = Lnrpc_ChannelBalanceRequest()
            return $0.channelBalance(request).response
        }
    }

    var onChainAddressSingle: Single<Lnrpc_NewAddressResponse> {
        connection.unaryCall() {
            let request = Lnrpc_NewAddressRequest()
            return $0.newAddress(request).response
        }
    }

    var channelsSingle: Single<Lnrpc_ListChannelsResponse> {
        connection.unaryCall() {
            let request = Lnrpc_ListChannelsRequest()
            return $0.listChannels(request).response
        }
    }

    var closedChannelsSingle: Single<Lnrpc_ClosedChannelsResponse> {
        connection.unaryCall() {
            let request = Lnrpc_ClosedChannelsRequest()
            return $0.closedChannels(request).response
        }
    }

    var pendingChannelsSingle: Single<Lnrpc_PendingChannelsResponse> {
        connection.unaryCall() {
            let request = Lnrpc_PendingChannelsRequest()
            return $0.pendingChannels(request).response
        }
    }

    var paymentsSingle: Single<Lnrpc_ListPaymentsResponse> {
        connection.unaryCall() {
            let request = Lnrpc_ListPaymentsRequest()
            return $0.listPayments(request).response
        }
    }

    init(rpcCredentials: RpcCredentials) throws {
        connection = try LndNioConnection(rpcCredentials: rpcCredentials)
        walletUnlocker = WalletUnlocker(connection: connection)
    }
    
    func scheduleStatusUpdates() {
        Observable<Int>.interval(.seconds(3), scheduler: SerialDispatchQueueScheduler(qos: .background))
            .flatMap { [weak self] _ -> Observable<NodeStatus> in
                guard let node = self else {
                    return .empty()
                }
                
                return node.fetchStatusSingle().asObservable()
            }
            .subscribe(onNext: { [weak self] in self?.status = $0 })
            .disposed(by: disposeBag)
    }
    
    func invoicesSingle(pendingOnly: Bool, offset: UInt64, limit: UInt64, reversed: Bool) -> Single<Lnrpc_ListInvoiceResponse> {
        connection.unaryCall() {
            var request = Lnrpc_ListInvoiceRequest()
            request.pendingOnly = pendingOnly
            request.indexOffset = offset
            request.numMaxInvoices = limit
            request.reversed = reversed

            return $0.listInvoices(request).response
        }
    }

    func paySingle(invoice: String) -> Single<Lnrpc_SendResponse> {
        connection.unaryCall() {
            var request = Lnrpc_SendRequest()
            request.paymentRequest = invoice

           return  $0.sendPaymentSync(request).response
        }
    }

    func addInvoiceSingle(amount: Int64, memo: String) -> Single<Lnrpc_AddInvoiceResponse> {
        connection.unaryCall() {
            var invoice = Lnrpc_Invoice()
            invoice.value = amount
            invoice.memo = memo

            return $0.addInvoice(invoice).response
        }
    }

    func unlockWalletSingle(password: Data) -> Single<Void> {
        if walletUnlocker.isUnlocking() {
            return Single.error(WalletUnlocker.UnlockingException())
        }
        
        return walletUnlocker.startUnlock(password: password)
    }

    func decodeSingle(paymentRequest: String) -> Single<Lnrpc_PayReq> {
        connection.unaryCall() {
            var request = Lnrpc_PayReqString()
            request.payReq = paymentRequest

            return $0.decodePayReq(request).response
        }
    }

    func openChannelSingle(nodePubKey: Data, amount: Int64) -> Observable<Lnrpc_OpenStatusUpdate> {
        connection.serverStreamCall() { client, handler -> ServerStreamingCall<Lnrpc_OpenChannelRequest, Lnrpc_OpenStatusUpdate> in
            var request = Lnrpc_OpenChannelRequest()
            request.nodePubkey = nodePubKey
            request.satPerByte = 2 // todo: extract as param
            request.localFundingAmount = amount

            return client.openChannel(request, handler: handler)
        }
    }

    func closeChannelSingle(channelPoint: String, forceClose: Bool) throws -> Observable<Lnrpc_CloseStatusUpdate> {
        let channelPointParts = channelPoint.split(separator: ":")
        
        guard channelPointParts.count == 0, let outputIndex = UInt32(String(channelPointParts[1])) else {
            throw ArgumentError.wrongChannelPoint
        }

        return connection.serverStreamCall { client, handler -> ServerStreamingCall<Lnrpc_CloseChannelRequest, Lnrpc_CloseStatusUpdate> in
            var channelPoint = Lnrpc_ChannelPoint()
            channelPoint.fundingTxidStr = String(channelPointParts[0])
            channelPoint.outputIndex = outputIndex

            var request = Lnrpc_CloseChannelRequest()
            request.channelPoint = channelPoint
            request.satPerByte = 2 // todo: extract as param
            request.force = forceClose

            return client.closeChannel(request, handler: handler)
        }
    }

    func connectSingle(nodeAddress: String, nodePubKey: String) -> Single<Lnrpc_ConnectPeerResponse> {
        connection.unaryCall() {
            var lightningAddress = Lnrpc_LightningAddress()
            lightningAddress.pubkey = nodePubKey
            lightningAddress.host = nodeAddress

            var request = Lnrpc_ConnectPeerRequest()
            request.addr = lightningAddress

            return $0.connectPeer(request).response
        }
    }

    func validateAsync() -> Single<Void> {
        fetchStatusSingle()
            .flatMap {
                if case let .error(error) = $0 {
                    return Single.error(error)
                } else {
                    return Single.just(Void())
                }
            }
    }

    private func fetchStatusSingle() -> Single<NodeStatus> {
        infoSingle
            .map { $0.syncedToGraph ? .running : .syncing }
            .catchError { error in
                print("GET INFO ERROR: \(error) --- \(error.localizedDescription)")
                var status: NodeStatus

                if let grpcStatusError = error as? GRPCStatus {
                            if grpcStatusError.code == .unimplemented {
                                status = .locked
                            } else if
                                grpcStatusError.code == .unavailable && self.walletUnlocker.isUnlocking() {
                                status = .unlocking
                            } else {
                                status = .error(error: grpcStatusError)
                            }
                } else {
                    status = .error(error: error)
                }

                return Single.just(status)
            }
    }
}
