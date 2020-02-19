import UIKit
import ThemeKit
import LightningKit

class NodeConnectRouter {
    weak var viewController: UIViewController?
}

extension NodeConnectRouter: INodeConnectRouter {

    func showMain() {
        UIApplication.shared.keyWindow?.set(newRootController: MainRouter.module())
    }

}

extension NodeConnectRouter {

    static func module(credentials: RpcCredentials) -> UIViewController {
        let router = NodeConnectRouter()
        let interactor = NodeConnectInteractor(walletManager: App.shared.walletManager)
        let presenter = NodeConnectPresenter(interactor: interactor, router: router, credentials: credentials)
        let viewController = NodeConnectViewController(delegate: presenter)

        presenter.view = viewController
        interactor.delegate = presenter
        router.viewController = viewController

        return viewController
    }

}
