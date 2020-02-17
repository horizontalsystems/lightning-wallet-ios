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
//        try? App.shared.keychainKit.secureStorage.set(value: true, for: "logged_in")
//        UIApplication.shared.keyWindow?.set(newRootController: MainRouter.module())
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
