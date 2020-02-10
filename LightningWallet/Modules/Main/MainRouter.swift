import UIKit
import ThemeKit

class MainRouter {

    enum Tab: Int {
        case settings
    }

    static func module(selectedTab: Tab = .settings) -> UIViewController {
        let viewControllers = [
            settingsNavigation
        ]

        let viewController = MainViewController(viewControllers: viewControllers, selectedIndex: selectedTab.rawValue)

        App.shared.pinKitDelegate.viewController = viewController

        return viewController
    }

    private static var settingsNavigation: UIViewController {
        ThemeNavigationController(rootViewController: MainSettingsRouter.module())
    }

}
