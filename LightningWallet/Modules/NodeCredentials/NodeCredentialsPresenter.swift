import LightningKit

class NodeCredentialsPresenter {
    private static let validationInterval: TimeInterval = 3

    weak var view: INodeCredentialsView?

    private let interactor: INodeCredentialsInteractor
    private let router: INodeCredentialsRouter
    private let notificationTimer: INotificationTimer

    private var lastScannedCode: String?

    init(interactor: INodeCredentialsInteractor, router: INodeCredentialsRouter, notificationTimer: INotificationTimer) {
        self.interactor = interactor
        self.router = router
        self.notificationTimer = notificationTimer
    }

    private func process(string: String, notify: Bool) {
        guard lastScannedCode != string else {
            return
        }
        if notify {
            view?.notifyScan()
        }

        if let credentials = interactor.credentials(urlString: string) {
            view?.stopScan()
            view?.showDescription()

            router.openConnectNode(credentials: credentials)
        } else {
            view?.showError()

            lastScannedCode = string
            notificationTimer.start(interval: NodeCredentialsPresenter.validationInterval)
        }
    }
}

extension NodeCredentialsPresenter: INodeCredentialsViewDelegate {

    func onLoad() {
        view?.showDescription()
    }

    func onPaste() {
        if let string = interactor.pasteboard {
            process(string: string, notify: false)
        } else {
            notificationTimer.start(interval: NodeCredentialsPresenter.validationInterval)
            view?.showEmptyPasteboard()
        }
    }

    func onScan(string: String) {
        process(string: string, notify: true)
    }

}

extension NodeCredentialsPresenter: INodeCredentialsInteractorDelegate {
}

extension NodeCredentialsPresenter: INotificationTimerDelegate {

    func onFire() {
        view?.showDescription()
    }

}
