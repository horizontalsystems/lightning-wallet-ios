import LightningKit
import RxSwift

class NodeConnectPresenter {
    weak var view: INodeConnectView?

    private let interactor: INodeConnectInteractor
    private let router: INodeConnectRouter

    private let credentials: RpcCredentials

    init(interactor: INodeConnectInteractor, router: INodeConnectRouter, credentials: RpcCredentials) {
        self.interactor = interactor
        self.router = router
        self.credentials = credentials
    }

}

extension NodeConnectPresenter: INodeConnectViewDelegate {

    func onLoad() {
        view?.show(address: "\(credentials.host):\(credentials.port)")
    }

    func onTapConnect() {
        view?.showConnecting()
        interactor.validate(credentials: credentials)
    }

}

extension NodeConnectPresenter: INodeConnectInteractorDelegate {

    func didValidateCredentials() {
        view?.hideConnecting()

        interactor.saveWallet(credentials: credentials)
        router.showMain()
    }

    func didFailToValidateCredentials(error: Error) {
        view?.showError(error: error)
    }

}
