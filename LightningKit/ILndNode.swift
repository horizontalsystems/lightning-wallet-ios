import Foundation
import GRPC
import RxSwift

protocol ILndNode {
    var statusObservable: Observable<NodeStatus> { get }
    func getInfo() -> Single<Lnrpc_GetInfoResponse>
    func getWalletBalance() -> Single<Lnrpc_WalletBalanceResponse>
    func getChannelBalance() -> Single<Lnrpc_ChannelBalanceResponse>
    func listChannels() -> Single<Lnrpc_ListChannelsResponse>
    func listClosedChannels() -> Single<Lnrpc_ClosedChannelsResponse>
    func listPendingChannels() -> Single<Lnrpc_PendingChannelsResponse>
    func listPayments() -> Single<Lnrpc_ListPaymentsResponse>
    func listInvoices(pendingOnly: Bool, offset: UInt64, limit: UInt64, reversed: Bool) -> Single<Lnrpc_ListInvoiceResponse>
    func invoicesObservable() -> Observable<Lnrpc_Invoice>
    func channelsObservable() -> Observable<Lnrpc_ChannelEventUpdate>
    func transactionsObservable() -> Observable<Lnrpc_Transaction>

    func payInvoice(invoice: String) -> Single<Lnrpc_SendResponse>
    func addInvoice(amount: Int64, memo: String) -> Single<Lnrpc_AddInvoiceResponse>
    func unlockWallet(password: Data) -> Single<Void>
    func decodePayReq(req: String) -> Single<Lnrpc_PayReq>
    func openChannel(nodePubKey: Data, amount: Int64) -> Observable<Lnrpc_OpenStatusUpdate>
    func closeChannel(channelPoint: String, forceClose: Bool) throws -> Observable<Lnrpc_CloseStatusUpdate>
    func connect(nodeAddress: String, nodePubKey: String) -> Single<Lnrpc_ConnectPeerResponse>
    func getOnChainAddress() -> Single<Lnrpc_NewAddressResponse>
}
