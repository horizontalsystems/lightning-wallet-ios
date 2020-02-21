import LightningKit

class ChannelsPresenter {
    weak var view: IChannelsView?

    private let interactor: IChannelsInteractor
    private let router: IChannelsRouter

    init(interactor: IChannelsInteractor, router: IChannelsRouter) {
        self.interactor = interactor
        self.router = router
    }

}

extension ChannelsPresenter: IChannelsViewDelegate {

    func onLoad() {
        interactor.fetchOpenChannels()
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
        let factory = ChannelsViewItemFactory()
        let viewItems = openChannels.map {
            factory.viewItem(channel: $0)
        }
        view?.show(viewItems: viewItems)
    }

}

class ChannelsViewItemFactory {

    func viewItem(channel: Lnrpc_Channel) -> ChannelViewItem {
        ChannelViewItem(
                remotePubKey: channel.remotePubkey,
                localBalance: Int(channel.localBalance),
                remoteBalance: Int(channel.remoteBalance)
        )
    }

}
