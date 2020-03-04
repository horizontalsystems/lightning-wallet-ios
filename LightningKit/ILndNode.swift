import Foundation
import GRPC
import RxSwift

protocol ILndNode {
    var statusObservable: Observable<NodeStatus> { get }
    var invoicesObservable: Observable<Lnrpc_Invoice> { get }
    var channelsObservable: Observable<Lnrpc_ChannelEventUpdate> { get }
    var transactionsObservable: Observable<Lnrpc_Transaction> { get }

    var infoSingle: Single<Lnrpc_GetInfoResponse> { get }
    var walletBalanceSingle: Single<Lnrpc_WalletBalanceResponse> { get }
    var channelBalanceSingle: Single<Lnrpc_ChannelBalanceResponse> { get }
    var onChainAddressSingle: Single<Lnrpc_NewAddressResponse> { get }

    var channelsSingle: Single<Lnrpc_ListChannelsResponse> { get }
    var closedChannelsSingle: Single<Lnrpc_ClosedChannelsResponse> { get }
    var pendingChannelsSingle: Single<Lnrpc_PendingChannelsResponse> { get }
    var paymentsSingle: Single<Lnrpc_ListPaymentsResponse> { get }
    var transactionsSingle: Single<Lnrpc_TransactionDetails> { get }
    var newSeedSingle: Single<Lnrpc_GenSeedResponse> { get }

    func invoicesSingle(request: Lnrpc_ListInvoiceRequest) -> Single<Lnrpc_ListInvoiceResponse>
    func paySingle(request: Lnrpc_SendRequest) -> Single<Lnrpc_SendResponse>
    func addInvoiceSingle(invoice: Lnrpc_Invoice) -> Single<Lnrpc_AddInvoiceResponse>
    func unlockWalletSingle(request: Lnrpc_UnlockWalletRequest) -> Single<Void>
    func decodeSingle(paymentRequest: Lnrpc_PayReqString) -> Single<Lnrpc_PayReq>
    func openChannelSingle(request: Lnrpc_OpenChannelRequest) -> Observable<Lnrpc_OpenStatusUpdate>
    func closeChannelSingle(request: Lnrpc_CloseChannelRequest) throws -> Observable<Lnrpc_CloseStatusUpdate>
    func connectSingle(request: Lnrpc_ConnectPeerRequest) -> Single<Lnrpc_ConnectPeerResponse>

    func initWalletSingle(request: Lnrpc_InitWalletRequest) -> Single<Void>
}
