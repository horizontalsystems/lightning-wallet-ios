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
}

protocol IChannelsInteractorDelegate: AnyObject {
    func didUpdate(openChannels: [Lnrpc_Channel])
}

struct ChannelViewItem {
    let remotePubKey: String
    let localBalance: Int
    let remoteBalance: Int
}
