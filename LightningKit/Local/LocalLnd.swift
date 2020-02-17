import Lndmobile
import RxSwift
import SwiftProtobuf

class LocalLnd: ILndNode {
    class NodeNotRetained: Error {}
    
    private let credentials: LocalNodeCredentials
    private let disposeBag = DisposeBag()
    
    private let statusSubject = PublishSubject<NodeStatus>()
    var statusObservable: Observable<NodeStatus> { statusSubject.asObservable() }
    private(set) var status: NodeStatus = .connecting {
        didSet {
            if status != oldValue {
                statusSubject.onNext(status)
            }
        }
    }
    
    init(credentials: LocalNodeCredentials) {
        self.credentials = credentials
    }

    func start() -> Single<Void> {
        let args = "--lnddir=\(credentials.lndDirPath) --bitcoin.active --bitcoin.mainnet --debuglevel=warn --no-macaroons --nolisten --norest --bitcoin.node=neutrino --routing.assumechanvalid"

        return Single<Void>.create { emitter in
            let unlockerCallback = VoidResponseCallback(emitter: emitter)
            
            LndmobileStart(args, unlockerCallback, nil)
            return Disposables.create()
        }
    }
    
    func scheduleStatusUpdates() {
        Observable<Int>.interval(.seconds(3), scheduler: SerialDispatchQueueScheduler(qos: .background))
            .flatMap { [weak self] _ -> Observable<NodeStatus> in
                guard let node = self else {
                    return .empty()
                }

                return node.fetchStatus().asObservable()
            }
            .subscribe(onNext: { [weak self] in self?.status = $0 })
            .disposed(by: disposeBag)
    }

    func getInfo() -> Single<Lnrpc_GetInfoResponse> {
        Single<Lnrpc_GetInfoResponse>.create { emitter in
            let msg = try! Lnrpc_GetInfoRequest().serializedData()

            LndmobileGetInfo(msg, MessageResponseCallback(emitter: emitter))

            return Disposables.create()
        }
    }
    
    func getWalletBalance() -> Single<Lnrpc_WalletBalanceResponse> {
        Single.error(WalletUnlocker.UnlockingException())
    }
    
    func getChannelBalance() -> Single<Lnrpc_ChannelBalanceResponse> {
        Single.error(WalletUnlocker.UnlockingException())
    }
    
    func listChannels() -> Single<Lnrpc_ListChannelsResponse> {
        Single.error(WalletUnlocker.UnlockingException())
    }
    
    func listClosedChannels() -> Single<Lnrpc_ClosedChannelsResponse> {
        Single.error(WalletUnlocker.UnlockingException())
    }
    
    func listPendingChannels() -> Single<Lnrpc_PendingChannelsResponse> {
        Single.error(WalletUnlocker.UnlockingException())
    }
    
    func listPayments() -> Single<Lnrpc_ListPaymentsResponse> {
        Single.error(WalletUnlocker.UnlockingException())
    }
    
    func listInvoices(pendingOnly: Bool, offset: UInt64, limit: UInt64, reversed: Bool) -> Single<Lnrpc_ListInvoiceResponse> {
        Single.error(WalletUnlocker.UnlockingException())
    }
    
    func invoicesObservable() -> Observable<Lnrpc_Invoice> {
        Observable.error(WalletUnlocker.UnlockingException())
    }
    
    func channelsObservable() -> Observable<Lnrpc_ChannelEventUpdate> {
        Observable.error(WalletUnlocker.UnlockingException())
    }
    
    func payInvoice(invoice: String) -> Single<Lnrpc_SendResponse> {
        Single.error(WalletUnlocker.UnlockingException())
    }
    
    func addInvoice(amount: Int64, memo: String) -> Single<Lnrpc_AddInvoiceResponse> {
        Single.error(WalletUnlocker.UnlockingException())
    }
    
    func unlockWallet(password: Data) -> Single<Void> {
        Single.error(WalletUnlocker.UnlockingException())
    }
    
    func decodePayReq(req: String) -> Single<Lnrpc_PayReq> {
        Single.error(WalletUnlocker.UnlockingException())
    }
    
    func openChannel(nodePubKey: Data, amount: Int64) -> Observable<Lnrpc_OpenStatusUpdate> {
        Observable.error(WalletUnlocker.UnlockingException())
    }
    
    func closeChannel(channelPoint: String, forceClose: Bool) throws -> Observable<Lnrpc_CloseStatusUpdate> {
        Observable.error(WalletUnlocker.UnlockingException())
    }
    
    func connect(nodeAddress: String, nodePubKey: String) -> Single<Lnrpc_ConnectPeerResponse> {
        Single.error(WalletUnlocker.UnlockingException())
    }
    
    func getOnChainAddress() -> Single<Lnrpc_NewAddressResponse> {
        Single.error(WalletUnlocker.UnlockingException())
    }
    
    func createWallet(password: String) -> Single<[String]> {
        genSeed()
            .flatMap { [weak self] genSeedResponse in
                guard let node = self else {
                    return Single<[String]>.error(NodeNotRetained())
                }
                
                return node.initWallet(mnemonicWords: genSeedResponse.cipherSeedMnemonic, password: password)
                    .do(onSuccess: { [weak self] _ in self?.scheduleStatusUpdates() })
                    .map { _ in genSeedResponse.cipherSeedMnemonic }
            }
    }
    
    func genSeed() -> Single<Lnrpc_GenSeedResponse> {
        Single.create { emitter in
            let msg = try! Lnrpc_GenSeedRequest().serializedData()
            
            LndmobileGenSeed(msg, MessageResponseCallback(emitter: emitter))
            
            return Disposables.create()
        }
    }
    
    func initWallet(mnemonicWords: [String], password: String) -> Single<Void> {
        Single.create { emitter in
            var msg = Lnrpc_InitWalletRequest()
            msg.cipherSeedMnemonic = mnemonicWords
            msg.walletPassword = Data(Array(password.utf8))
            
            LndmobileInitWallet(try! msg.serializedData(), VoidResponseCallback(emitter: emitter))
            
            return Disposables.create()
        }
    }
    
    private func fetchStatus() -> Single<NodeStatus> {
        return getInfo()
            .map { $0.syncedToGraph ? .running : .syncing }
            .catchError { error in
                var status: NodeStatus

//                if let grpcStatusError = error as? GRPCStatus {
//                            if grpcStatusError.code == .unimplemented {
//                                status = .locked
////                            } else if let walletUnlocker = self?.walletUnlocker,
////                                grpcStatusError.code == .unavailable && walletUnlocker.isUnlocking() {
////                                status = .unlocking
//                            } else {
//                                status = .error(error: grpcStatusError)
//                            }
//                } else {
                    status = .error(error: error)
//                }

                return Single.just(status)
            }
    }
}
