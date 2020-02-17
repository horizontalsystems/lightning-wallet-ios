import UIKit
import ThemeKit

class MainRouter {
    weak var viewController: UIViewController?
}

extension MainRouter: IMainRouter {

    func openSettings() {
        viewController?.navigationController?.pushViewController(MainSettingsRouter.module(), animated: true)
    }

    func openTransactions() {
        viewController?.present(ThemeNavigationController(rootViewController: TransactionsRouter.module()), animated: true)
    }

}

extension MainRouter {

    static func module() -> UIViewController {
        let router = MainRouter()
        let interactor = MainInteractor(currencyKit: App.shared.currencyKit)
        let presenter = MainPresenter(interactor: interactor, router: router, viewFactory: ValueFormatterFactory())
        let viewController = MainViewController(delegate: presenter)

        presenter.view = viewController
        router.viewController = viewController

        App.shared.pinKitDelegate.viewController = viewController

        return ThemeNavigationController(rootViewController: viewController)
    }

}
