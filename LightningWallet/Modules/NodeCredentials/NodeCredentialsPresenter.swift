import LightningKit

class NodeCredentialsPresenter {
    weak var view: INodeCredentialsView?

    private let interactor: INodeCredentialsInteractor
    private let router: INodeCredentialsRouter

    // TODO: replace scanned flag with better implementation
    private var scanned = false

    init(interactor: INodeCredentialsInteractor, router: INodeCredentialsRouter) {
        self.interactor = interactor
        self.router = router
    }

    private func process(string: String) {
        guard !scanned else {
            return
        }

        if let credentials = interactor.credentials(urlString: string) {
            scanned = true
            router.openConnectNode(credentials: credentials)
        } else {
            view?.showError()
        }
    }
}

extension NodeCredentialsPresenter: INodeCredentialsViewDelegate {

    func onLoad() {
        view?.showDescription()
        scanned = false
    }

    func onPaste() {
        if let string = interactor.pasteboard {
            process(string: string)
        }
    }

    func onScan(string: String) {
        process(string: string)
    }

}

extension NodeCredentialsPresenter: INodeCredentialsInteractorDelegate {
}
