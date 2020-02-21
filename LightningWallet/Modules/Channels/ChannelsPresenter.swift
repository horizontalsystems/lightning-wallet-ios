import LightningKit

class ChannelsPresenter {
    weak var view: IChannelsView?

    private let interactor: IChannelsInteractor
    private let router: IChannelsRouter

    private var openChannels: [Lnrpc_Channel] = []
    private var pendingOpenChannels: [Lnrpc_PendingChannelsResponse.PendingOpenChannel] = []
    private var pendingClosingChannels: [Lnrpc_PendingChannelsResponse.ClosedChannel] = []
    private var pendingForceClosingChannels: [Lnrpc_PendingChannelsResponse.ForceClosedChannel] = []
    private var waitingCloseChannels: [Lnrpc_PendingChannelsResponse.WaitingCloseChannel] = []

    init(interactor: IChannelsInteractor, router: IChannelsRouter) {
        self.interactor = interactor
        self.router = router
    }

    private func syncView() {
        let factory = ChannelsViewItemFactory()

        let openChannelViewItems = openChannels.map { factory.viewItem(channel: $0) }
        let pendingOpenChannelViewItems = pendingOpenChannels.map { factory.viewItem(state: .pendingOpen, pendingChannel: $0.channel) }
        let pendingClosingChannelViewItems = pendingClosingChannels.map { factory.viewItem(state: .pendingClosing, pendingChannel: $0.channel) }
        let pendingForceClosingChannelViewItems = pendingForceClosingChannels.map { factory.viewItem(state: .pendingForceClosing, pendingChannel: $0.channel) }
        let waitingCloseChannelViewItems = waitingCloseChannels.map { factory.viewItem(state: .waitingClose, pendingChannel: $0.channel) }

        view?.show(viewItems: openChannelViewItems + pendingOpenChannelViewItems + pendingClosingChannelViewItems + pendingForceClosingChannelViewItems + waitingCloseChannelViewItems)
    }

}

extension ChannelsPresenter: IChannelsViewDelegate {

    func onLoad() {
        interactor.fetchOpenChannels()
        interactor.fetchPendingChannels()
    }

    func onClose() {
        router.dismiss()
    }

    func onNewChannel() {
        print("onNewChannel")
    }

    func onSelectOpen() {
        print("onSelectOpen")
    }

    func onSelectClosed() {
        print("onSelectClosed")
    }

}

extension ChannelsPresenter: IChannelsInteractorDelegate {

    func didUpdate(openChannels: [Lnrpc_Channel]) {
        self.openChannels = openChannels
        syncView()
    }

    func didUpdatePendingChannels(response: Lnrpc_PendingChannelsResponse) {
        self.pendingOpenChannels = response.pendingOpenChannels
        self.pendingClosingChannels = response.pendingClosingChannels
        self.pendingForceClosingChannels = response.pendingForceClosingChannels
        self.waitingCloseChannels = response.waitingCloseChannels
        syncView()
    }

}

class ChannelsViewItemFactory {

    func viewItem(channel: Lnrpc_Channel) -> ChannelViewItem {
        ChannelViewItem(
                state: .open,
                remotePubKey: channel.remotePubkey,
                localBalance: Int(channel.localBalance),
                remoteBalance: Int(channel.remoteBalance)
        )
    }

    func viewItem(state: ChannelViewItem.State, pendingChannel: Lnrpc_PendingChannelsResponse.PendingChannel) -> ChannelViewItem {
        ChannelViewItem(
                state: state,
                remotePubKey: pendingChannel.remoteNodePub,
                localBalance: Int(pendingChannel.localBalance),
                remoteBalance: Int(pendingChannel.remoteBalance)
        )
    }

}
