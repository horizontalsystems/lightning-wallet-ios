import UIKit
import StorageKit

class LaunchRouter {

    static func module() -> UIViewController {
        let interactor: ILaunchInteractor = LaunchInteractor(
                keychainKit: App.shared.keychainKit,
                localStorage: App.shared.localStorage
        )
        let presenter: ILaunchPresenter = LaunchPresenter(interactor: interactor)

        switch presenter.launchMode {
        case .noPasscode: return NoPasscodeViewController()
        case .welcome: return WelcomeScreenRouter.module()
        case .main: return WelcomeScreenRouter.module()
        }
    }

}
