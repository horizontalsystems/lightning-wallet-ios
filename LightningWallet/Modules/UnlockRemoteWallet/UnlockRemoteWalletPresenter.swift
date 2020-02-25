class UnlockRemoteWalletPresenter {
    weak var view: IUnlockRemoteWalletView?

    private let interactor: IUnlockRemoteWalletInteractor
    private let router: IUnlockRemoteWalletRouter

    init(interactor: IUnlockRemoteWalletInteractor, router: IUnlockRemoteWalletRouter) {
        self.interactor = interactor
        self.router = router
    }

}

extension UnlockRemoteWalletPresenter: IUnlockRemoteWalletViewDelegate {

    func onLoad() {
    }

    func onTapUnlock(password: String?) {
        guard let password = password else {
            return
        }

        view?.showUnlocking()
        interactor.unlockWallet(password: password)
    }

    func onTapCancel() {
        router.close()
    }

}

extension UnlockRemoteWalletPresenter: IUnlockRemoteWalletInteractorDelegate {

    func didUnlockWallet() {
        view?.hideUnlocking()
        router.close()
    }

    func didFailToUnlockWallet(error: Error) {
        view?.show(error: error)
    }

}
