import UIKit
import ThemeKit
import LightningKit

class UnlockRemoteWalletRouter {
    weak var viewController: UIViewController?
}

extension UnlockRemoteWalletRouter: IUnlockRemoteWalletRouter {

    func close() {
        viewController?.dismiss(animated: true)
    }

}

extension UnlockRemoteWalletRouter {

    static func module() -> UIViewController {
        guard let lightningKit = App.shared.lightningKitManager.currentKit else {
            // TODO: show empty view controller with message
            fatalError()
        }

        let router = UnlockRemoteWalletRouter()
        let interactor = UnlockRemoteWalletInteractor(lightningKit: lightningKit)
        let presenter = UnlockRemoteWalletPresenter(interactor: interactor, router: router)
        let viewController = UnlockRemoteWalletViewController(delegate: presenter)

        presenter.view = viewController
        interactor.delegate = presenter
        router.viewController = viewController

        App.shared.pinKitDelegate.viewController = viewController

        return ThemeNavigationController(rootViewController: viewController)
    }

}
