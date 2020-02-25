import Foundation
import GRPC
import NIO
import NIOSSL
import NIOHPACK
import Logging
import RxSwift

class RemoteLnd: ILndNode {
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

    var statusObservable: Observable<NodeStatus> {
        statusSubject.asObservable()
    }

    var invoicesObservable: Observable<Lnrpc_Invoice> {
        connection.serverStreamCall() { client, handler -> ServerStreamingCall<Lnrpc_InvoiceSubscription, Lnrpc_Invoice> in
            client.subscribeInvoices(Lnrpc_InvoiceSubscription(), handler: handler)
        }
    }

    var channelsObservable: Observable<Lnrpc_ChannelEventUpdate> {
        connection.serverStreamCall() { client, handler -> ServerStreamingCall<Lnrpc_ChannelEventSubscription, Lnrpc_ChannelEventUpdate> in
            client.subscribeChannelEvents(Lnrpc_ChannelEventSubscription(), handler: handler)
        }
    }

    var transactionsObservable: Observable<Lnrpc_Transaction> {
        connection.serverStreamCall() { client, handler -> ServerStreamingCall<Lnrpc_GetTransactionsRequest, Lnrpc_Transaction> in
            client.subscribeTransactions(Lnrpc_GetTransactionsRequest(), handler: handler)
        }
    }

    var infoSingle: Single<Lnrpc_GetInfoResponse> {
        connection.unaryCall() {
            $0.getInfo(Lnrpc_GetInfoRequest()).response
        }
    }

    var walletBalanceSingle: Single<Lnrpc_WalletBalanceResponse> {
        connection.unaryCall() {
            $0.walletBalance(Lnrpc_WalletBalanceRequest()).response
        }
    }

    var channelBalanceSingle: Single<Lnrpc_ChannelBalanceResponse> {
        connection.unaryCall() {
            $0.channelBalance(Lnrpc_ChannelBalanceRequest()).response
        }
    }

    var onChainAddressSingle: Single<Lnrpc_NewAddressResponse> {
        connection.unaryCall() {
            $0.newAddress(Lnrpc_NewAddressRequest()).response
        }
    }

    var channelsSingle: Single<Lnrpc_ListChannelsResponse> {
        connection.unaryCall() {
            $0.listChannels(Lnrpc_ListChannelsRequest()).response
        }
    }

    var closedChannelsSingle: Single<Lnrpc_ClosedChannelsResponse> {
        connection.unaryCall() {
            $0.closedChannels(Lnrpc_ClosedChannelsRequest()).response
        }
    }

    var pendingChannelsSingle: Single<Lnrpc_PendingChannelsResponse> {
        connection.unaryCall() {
            $0.pendingChannels(Lnrpc_PendingChannelsRequest()).response
        }
    }

    var paymentsSingle: Single<Lnrpc_ListPaymentsResponse> {
        connection.unaryCall() {
            $0.listPayments(Lnrpc_ListPaymentsRequest()).response
        }
    }
    
    var transactionsSingle: Single<Lnrpc_TransactionDetails> {
        connection.unaryCall {
            $0.getTransactions(Lnrpc_GetTransactionsRequest()).response
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

    func invoicesSingle(request: Lnrpc_ListInvoiceRequest) -> Single<Lnrpc_ListInvoiceResponse> {
        connection.unaryCall() {
            $0.listInvoices(request).response
        }
    }

    func paySingle(request: Lnrpc_SendRequest) -> Single<Lnrpc_SendResponse> {
        connection.unaryCall() {
            $0.sendPaymentSync(request).response
        }
    }

    func addInvoiceSingle(invoice: Lnrpc_Invoice) -> Single<Lnrpc_AddInvoiceResponse> {
        connection.unaryCall() {
            $0.addInvoice(invoice).response
        }
    }

    func unlockWalletSingle(request: Lnrpc_UnlockWalletRequest) -> Single<Void> {
        if walletUnlocker.isUnlocking() {
            return Single.error(WalletUnlocker.UnlockingException())
        }

        return walletUnlocker.startUnlock(request: request)
    }

    func decodeSingle(paymentRequest: Lnrpc_PayReqString) -> Single<Lnrpc_PayReq> {
        connection.unaryCall() {
            $0.decodePayReq(paymentRequest).response
        }
    }

    func openChannelSingle(request: Lnrpc_OpenChannelRequest) -> Observable<Lnrpc_OpenStatusUpdate> {
        connection.serverStreamCall() { client, handler -> ServerStreamingCall<Lnrpc_OpenChannelRequest, Lnrpc_OpenStatusUpdate> in
            client.openChannel(request, handler: handler)
        }
    }

    func closeChannelSingle(request: Lnrpc_CloseChannelRequest) throws -> Observable<Lnrpc_CloseStatusUpdate> {
        connection.serverStreamCall { client, handler -> ServerStreamingCall<Lnrpc_CloseChannelRequest, Lnrpc_CloseStatusUpdate> in
            client.closeChannel(request, handler: handler)
        }
    }

    func connectSingle(request: Lnrpc_ConnectPeerRequest) -> Single<Lnrpc_ConnectPeerResponse> {
        connection.unaryCall() {
            $0.connectPeer(request).response
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
                .map {
                    $0.syncedToGraph ? .running : .syncing
                }
                .catchError { error in
                    var status: NodeStatus

                    if let grpcStatusError = error as? GRPCStatus {
                        if grpcStatusError.code == .unimplemented {
                            status = .locked
                        } else if
                                grpcStatusError.code == .unavailable && self.walletUnlocker.isUnlocking() {
                            status = .unlocking
                        } else {
                            status = .error(grpcStatusError)
                        }
                    } else {
                        status = .error(error)
                    }

                    return Single.just(status)
                }
    }
}
