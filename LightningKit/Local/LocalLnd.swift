import Lndmobile
import RxSwift
import SwiftProtobuf

class LocalLnd: ILndNode {
    class NodeNotRetained: Error {}

    private let filesDir: String
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
        Observable.create { emitter in
            LndmobileSubscribeInvoices(try! Lnrpc_InvoiceSubscription().serializedData(), MessageResponseStream(emitter: emitter))
            
            return Disposables.create()
        }
    }

    var channelsObservable: Observable<Lnrpc_ChannelEventUpdate> {
        Observable.create { emitter in
            LndmobileSubscribeChannelEvents(try! Lnrpc_ChannelEventSubscription().serializedData(), MessageResponseStream(emitter: emitter))
            
            return Disposables.create()
        }
    }

    var transactionsObservable: Observable<Lnrpc_Transaction> {
        Observable.create { emitter in
            LndmobileSubscribeTransactions(try! Lnrpc_GetTransactionsRequest().serializedData(), MessageResponseStream(emitter: emitter))
            
            return Disposables.create()
        }
    }

    var infoSingle: Single<Lnrpc_GetInfoResponse> {
        Single<Lnrpc_GetInfoResponse>.create { emitter in
            LndmobileGetInfo(try! Lnrpc_GetInfoRequest().serializedData(), MessageResponseCallback(emitter: emitter))

            return Disposables.create()
        }
    }

    var walletBalanceSingle: Single<Lnrpc_WalletBalanceResponse> {
        Single.create { emitter in
            LndmobileWalletBalance(try! Lnrpc_WalletBalanceRequest().serializedData(), MessageResponseCallback(emitter: emitter))

            return Disposables.create()
        }
    }

    var channelBalanceSingle: Single<Lnrpc_ChannelBalanceResponse> {
        Single.create { emitter in
            LndmobileChannelBalance(try! Lnrpc_ChannelBalanceRequest().serializedData(), MessageResponseCallback(emitter: emitter))

            return Disposables.create()
        }
    }

    var onChainAddressSingle: Single<Lnrpc_NewAddressResponse> {
        Single.create { emitter in
            LndmobileNewAddress(try! Lnrpc_NewAddressRequest().serializedData(), MessageResponseCallback(emitter: emitter))

            return Disposables.create()
        }
    }

    var channelsSingle: Single<Lnrpc_ListChannelsResponse> {
        Single.create { emitter in
            LndmobileListChannels(try! Lnrpc_ListChannelsRequest().serializedData(), MessageResponseCallback(emitter: emitter))

            return Disposables.create()
        }
    }

    var closedChannelsSingle: Single<Lnrpc_ClosedChannelsResponse> {
        Single.create { emitter in
            LndmobileClosedChannels(try! Lnrpc_ClosedChannelsRequest().serializedData(), MessageResponseCallback(emitter: emitter))

            return Disposables.create()
        }
    }

    var pendingChannelsSingle: Single<Lnrpc_PendingChannelsResponse> {
        Single.create { emitter in
            LndmobilePendingChannels(try! Lnrpc_PendingChannelsRequest().serializedData(), MessageResponseCallback(emitter: emitter))

            return Disposables.create()
        }
    }

    var paymentsSingle: Single<Lnrpc_ListPaymentsResponse> {
        Single.create { emitter in
            LndmobileListPayments(try! Lnrpc_ListPaymentsRequest().serializedData(), MessageResponseCallback(emitter: emitter))

            return Disposables.create()
        }
    }
    
    var transactionsSingle: Single<Lnrpc_TransactionDetails> {
        Single.create { emitter in
            LndmobileGetTransactions(try! Lnrpc_GetTransactionsRequest().serializedData(), MessageResponseCallback(emitter: emitter))
            
            return Disposables.create()
        }
    }

    init(filesDir: String) {
        self.filesDir = filesDir
    }

    private func genSeedSingle() -> Single<Lnrpc_GenSeedResponse> {
        Single.create { emitter in
            LndmobileGenSeed(try! Lnrpc_GenSeedRequest().serializedData(), MessageResponseCallback(emitter: emitter))

            return Disposables.create()
        }
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
        Single.create { emitter in
            LndmobileListInvoices(try! request.serializedData(), MessageResponseCallback(emitter: emitter))

            return Disposables.create()
        }
    }

    func paySingle(request: Lnrpc_SendRequest) -> Single<Lnrpc_SendResponse> {
        Single.create { emitter in
            LndmobileSendPaymentSync(try! request.serializedData(), MessageResponseCallback(emitter: emitter))

            return Disposables.create()
        }
    }

    func addInvoiceSingle(invoice: Lnrpc_Invoice) -> Single<Lnrpc_AddInvoiceResponse> {
        Single.create { emitter in
            LndmobileAddInvoice(try! invoice.serializedData(), MessageResponseCallback(emitter: emitter))

            return Disposables.create()
        }
    }

    func unlockWalletSingle(request: Lnrpc_UnlockWalletRequest) -> Single<Void> {
        Single<Void>.create { emitter in
            LndmobileUnlockWallet(try! request.serializedData(), VoidResponseCallback(emitter: emitter))

            return Disposables.create()
        }
    }

    func decodeSingle(paymentRequest: Lnrpc_PayReqString) -> Single<Lnrpc_PayReq> {
        Single.create { emitter in
            LndmobileDecodePayReq(try! paymentRequest.serializedData(), MessageResponseCallback(emitter: emitter))

            return Disposables.create()
        }
    }

    func openChannelSingle(request: Lnrpc_OpenChannelRequest) -> Observable<Lnrpc_OpenStatusUpdate> {
        Observable.create { emitter in
            LndmobileOpenChannel(try! request.serializedData(), MessageResponseStream(emitter: emitter))

            return Disposables.create()
        }
    }

    func closeChannelSingle(request: Lnrpc_CloseChannelRequest) throws -> Observable<Lnrpc_CloseStatusUpdate> {
        Observable.create { emitter in
            LndmobileCloseChannel(try! request.serializedData(), MessageResponseStream(emitter: emitter))
            
            return Disposables.create()
        }
    }

    func connectSingle(request: Lnrpc_ConnectPeerRequest) -> Single<Lnrpc_ConnectPeerResponse> {
        Single.create { emitter in
            LndmobileConnectPeer(try! request.serializedData(), MessageResponseCallback(emitter: emitter))

            return Disposables.create()
        }
    }

    func start() -> Single<Void> {
        let args = "--lnddir=\(filesDir) --bitcoin.active --bitcoin.mainnet --debuglevel=warn --no-macaroons --nolisten --norest --bitcoin.node=neutrino --routing.assumechanvalid --debuglevel=info"

        return Single<Void>.create { emitter in
            LndmobileStart(args, VoidResponseCallback(emitter: emitter), VoidResponseCallback(emitter: nil))

            return Disposables.create()
        }
    }

    func startAndUnlock(password: String) -> Single<Void> {
        start()
                .flatMap { [weak self] _ in
                    var request = Lnrpc_UnlockWalletRequest()
                    request.walletPassword = Data(Array(password.utf8))

                    return self?.unlockWalletSingle(request: request) ?? Single.error(NodeNotRetained())
                }
                .do(
                    onSuccess: { [weak self] _ in self?.scheduleStatusUpdates() },
                    onError: { [weak self] in self?.status = .error($0) }
                )
    }

    func createWalletSingle(password: String) -> Single<[String]> {
        genSeedSingle()
                .flatMap { [weak self] genSeedResponse in
                    guard let node = self else {
                        return Single<[String]>.error(NodeNotRetained())
                    }

                    return node.initWalletSingle(mnemonicWords: genSeedResponse.cipherSeedMnemonic, password: password, recoveryWindow: 0)
                            .do(
                                onSuccess: { [weak self] _ in self?.scheduleStatusUpdates() },
                                onError: { [weak self] in self?.status = .error($0) }
                            )
                            .map { _ in
                                genSeedResponse.cipherSeedMnemonic
                            }
                }
    }

    func restoreWalletSingle(words: [String], password: String) -> Single<Void> {
        initWalletSingle(mnemonicWords: words, password: password)
            .do(
                onSuccess: { [weak self] _ in self?.scheduleStatusUpdates() },
                onError: { [weak self] in self?.status = .error($0) }
            )
    }

    func initWalletSingle(mnemonicWords: [String], password: String, recoveryWindow: Int32 = 100) -> Single<Void> {
        Single.create { emitter in
            var msg = Lnrpc_InitWalletRequest()
            msg.cipherSeedMnemonic = mnemonicWords
            msg.walletPassword = Data(Array(password.utf8))
            msg.recoveryWindow = recoveryWindow

            LndmobileInitWallet(try! msg.serializedData(), VoidResponseCallback(emitter: emitter))

            return Disposables.create()
        }
    }

    private func fetchStatusSingle() -> Single<NodeStatus> {
        infoSingle
                .map {
                    $0.syncedToGraph ? .running : .syncing
                }
                .catchError { error in
                    Single.just(.error(error))
                }
    }
}
