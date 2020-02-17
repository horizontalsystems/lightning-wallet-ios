import Foundation

class NodeCredentialsPresenter {
    weak var view: INodeCredentialsView?

    private let interactor: INodeCredentialsInteractor
    private let router: INodeCredentialsRouter

    init(interactor: INodeCredentialsInteractor, router: INodeCredentialsRouter) {
        self.interactor = interactor
        self.router = router
    }

    private func process(string: String?) {
        do {
            let credentials = try interactor.parse(code: string)
            router.openConnectNode(someData: credentials)
        } catch {
            view?.showError()
        }
    }
}

extension NodeCredentialsPresenter: INodeCredentialsViewDelegate {

    func onLoad() {
        view?.showDescription()
    }

    func onPaste() {
        let string = interactor.pasteboard
        process(string: string)
    }

    func onScan(string: String) {
        process(string: string)
    }

}

extension NodeCredentialsPresenter: INodeCredentialsInteractorDelegate {

    func didFail() {
        view?.showError()
    }

    func didValidate(code: String) {
        view?.showDescription()
    }

}