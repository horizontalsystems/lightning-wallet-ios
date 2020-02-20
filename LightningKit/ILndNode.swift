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

    func invoicesSingle(pendingOnly: Bool, offset: UInt64, limit: UInt64, reversed: Bool) -> Single<Lnrpc_ListInvoiceResponse>
    func paySingle(invoice: String) -> Single<Lnrpc_SendResponse>
    func addInvoiceSingle(amount: Int64, memo: String) -> Single<Lnrpc_AddInvoiceResponse>
    func unlockWalletSingle(password: Data) -> Single<Void>
    func decodeSingle(paymentRequest: String) -> Single<Lnrpc_PayReq>
    func openChannelSingle(nodePubKey: Data, amount: Int64) -> Observable<Lnrpc_OpenStatusUpdate>
    func closeChannelSingle(channelPoint: String, forceClose: Bool) throws -> Observable<Lnrpc_CloseStatusUpdate>
    func connectSingle(nodeAddress: String, nodePubKey: String) -> Single<Lnrpc_ConnectPeerResponse>
}
