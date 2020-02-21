import LightningKit

protocol IChannelsView: class {
    func show(viewItems: [ChannelViewItem])
}

protocol IChannelsRouter {
    func dismiss()
}

protocol IChannelsViewDelegate {
    func onLoad()
    func onClose()
    func onNewChannel()
    func onSelectOpen()
    func onSelectClosed()
}

protocol IChannelsInteractor {
    func fetchOpenChannels()
    func fetchPendingChannels()
}

protocol IChannelsInteractorDelegate: AnyObject {
    func didUpdate(openChannels: [Lnrpc_Channel])
    func didUpdatePendingChannels(response: Lnrpc_PendingChannelsResponse)
}

struct ChannelViewItem {
    let state: State
    let remotePubKey: String
    let localBalance: Int
    let remoteBalance: Int

    enum State {
        case open
        case pendingOpen
        case pendingClosing
        case pendingForceClosing
        case waitingClose
    }
}
