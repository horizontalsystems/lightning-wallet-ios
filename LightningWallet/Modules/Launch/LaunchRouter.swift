import UIKit
import StorageKit

class LaunchRouter {

    static func module() -> UIViewController {
        let interactor: ILaunchInteractor = LaunchInteractor(keychainKit: App.shared.keychainKit, pinKit: App.shared.pinKit, walletManager: App.shared.walletManager)
        let presenter: ILaunchPresenter = LaunchPresenter(interactor: interactor)

        switch presenter.launchMode {
        case .noPasscode: return NoPasscodeViewController()
        case .welcome: return WelcomeScreenRouter.module()
        case .unlock: return LockScreenRouter.module(pinKit: App.shared.pinKit, appStart: true)
        case .main: return MainRouter.module()
        }
    }

}
