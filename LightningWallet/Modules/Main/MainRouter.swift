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

        return MainViewController(viewControllers: viewControllers, selectedIndex: selectedTab.rawValue)
    }

    private static var settingsNavigation: UIViewController {
        ThemeNavigationController(rootViewController: MainSettingsRouter.module())
    }

}
