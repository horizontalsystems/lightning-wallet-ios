import UIKit
import ThemeKit
import LightningKit

class NodeConnectRouter {
    weak var viewController: UIViewController?
}

extension NodeConnectRouter: INodeConnectRouter {

    func showMain() {
        try? App.shared.keychainKit.secureStorage.set(value: true, for: "logged_in")
        UIApplication.shared.keyWindow?.set(newRootController: MainRouter.module())
    }

}

extension NodeConnectRouter {

    static func module(credentials: RpcCredentials) -> UIViewController {
        let router = NodeConnectRouter()
        let interactor = NodeConnectInteractor()
        let presenter = NodeConnectPresenter(interactor: interactor, router: router, credentials: credentials)
        let viewController = NodeConnectViewController(delegate: presenter)

        presenter.view = viewController
        interactor.delegate = presenter
        router.viewController = viewController

        return viewController
    }

}
