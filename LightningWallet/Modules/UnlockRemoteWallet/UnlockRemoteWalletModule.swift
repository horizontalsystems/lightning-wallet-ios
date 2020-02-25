protocol IUnlockRemoteWalletRouter {
    func close()
}

protocol IUnlockRemoteWalletView: class {
    func showUnlocking()
    func hideUnlocking()
    func show(error: Error)
}

protocol IUnlockRemoteWalletViewDelegate {
    func onLoad()
    func onTapUnlock(password: String?)
    func onTapCancel()
}

protocol IUnlockRemoteWalletInteractor {
    func unlockWallet(password: String)
}

protocol IUnlockRemoteWalletInteractorDelegate: AnyObject {
    func didUnlockWallet()
    func didFailToUnlockWallet(error: Error)
}
