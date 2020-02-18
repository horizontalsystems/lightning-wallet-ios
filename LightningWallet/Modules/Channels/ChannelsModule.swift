protocol IChannelsView: class {
}

protocol IChannelsRouter {
    func dismiss()
}

protocol IChannelsViewDelegate {
    func onLoad()
    func onClose()
    func onNewChannel()
}
