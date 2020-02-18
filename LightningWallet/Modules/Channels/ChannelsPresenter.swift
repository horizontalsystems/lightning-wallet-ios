class ChannelsPresenter {
    weak var view: IChannelsView?
    var router: IChannelsRouter

    init(router: IChannelsRouter) {
        self.router = router
    }

}

extension ChannelsPresenter: IChannelsViewDelegate {

    func onLoad() {
        print("onLoad")
    }

    func onClose() {
        router.dismiss()
    }

    func onNewChannel() {
        print("onNewChannel")
    }

}
