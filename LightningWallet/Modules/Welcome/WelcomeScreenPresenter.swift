class WelcomeScreenPresenter {
    private let interactor: IWelcomeScreenInteractor
    private let router: IWelcomeScreenRouter

    weak var view: IWelcomeScreenView?

    init(interactor: IWelcomeScreenInteractor, router: IWelcomeScreenRouter) {
        self.interactor = interactor
        self.router = router
    }

}

extension WelcomeScreenPresenter: IWelcomeScreenViewDelegate {

    func viewDidLoad() {
        view?.set(appVersion: interactor.appVersion)
    }

    func onTapCreate() {
        router.showCreateWallet()
    }

    func onTapRestore() {
        router.showRestoreWallet()
    }

    func onTapConnect() {
        router.showConnectToRemoteNode()
    }

}
