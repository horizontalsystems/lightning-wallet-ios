protocol IWelcomeScreenView: class {
    func set(appVersion: String)
}

protocol IWelcomeScreenViewDelegate {
    func viewDidLoad()
    func onTapCreate()
    func onTapRestore()
    func onTapConnect()
}

protocol IWelcomeScreenInteractor {
    var appVersion: String { get }
}

protocol IWelcomeScreenRouter {
    func showCreateWallet()
    func showRestoreWallet()
    func showConnectToRemoteNode()
}
