import UIKit

class LaunchRouter {

    static func module() -> UIViewController {
        let interactor: ILaunchInteractor = LaunchInteractor(localStorage: App.shared.localStorage)
        let presenter: ILaunchPresenter = LaunchPresenter(interactor: interactor)

        switch presenter.launchMode {
        case .welcome: return WelcomeScreenRouter.module()
        case .main: return WelcomeScreenRouter.module()
        }
    }

}
