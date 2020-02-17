import Foundation

class NodeConnectPresenter {
    weak var view: INodeConnectView?

    private let interactor: INodeConnectInteractor
    private let router: INodeConnectRouter

    init(interactor: INodeConnectInteractor, router: INodeConnectRouter) {
        self.interactor = interactor
        self.router = router
    }

}

extension NodeConnectPresenter: INodeConnectViewDelegate {

    func onLoad() {
    }

}
