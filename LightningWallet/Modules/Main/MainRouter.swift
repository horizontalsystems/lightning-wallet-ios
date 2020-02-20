import UIKit
import ThemeKit
import LightningKit

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

    func openChannels() {
        viewController?.present(ThemeNavigationController(rootViewController: ChannelsRouter.module()), animated: true)
    }

}

extension MainRouter {

    static func module() -> UIViewController {
        guard let lightningKit = App.shared.lightningKitManager.currentKit else {
            // TODO: show empty view controller with message
            fatalError()
        }

        let router = MainRouter()
        let interactor = MainInteractor(lightningKit: lightningKit, currencyKit: App.shared.currencyKit)
        let presenter = MainPresenter(interactor: interactor, router: router, viewFactory: ValueFormatterFactory())
        let viewController = MainViewController(delegate: presenter)

        presenter.view = viewController
        interactor.delegate = presenter
        router.viewController = viewController

        App.shared.pinKitDelegate.viewController = viewController

        return ThemeNavigationController(rootViewController: viewController)
    }

}
