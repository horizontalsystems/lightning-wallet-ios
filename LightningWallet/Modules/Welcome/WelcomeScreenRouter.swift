import UIKit
import ThemeKit
import UIExtensions

class WelcomeScreenRouter {
    weak var viewController: UIViewController?
}

extension WelcomeScreenRouter: IWelcomeScreenRouter {

    func showCreateWallet() {
    }

    func showRestoreWallet() {
    }

    func showConnectToRemoteNode() {
        viewController?.navigationController?.pushViewController(NodeCredentialsRouter.module(), animated: true)
    }

}

extension WelcomeScreenRouter {

    static func module() -> UIViewController {
        let router = WelcomeScreenRouter()
        let interactor = WelcomeScreenInteractor()
        let presenter = WelcomeScreenPresenter(interactor: interactor, router: router)
        let viewController = WelcomeScreenViewController(delegate: presenter)

        presenter.view = viewController
        router.viewController = viewController

        return ThemeNavigationController(rootViewController: viewController)
    }

}
