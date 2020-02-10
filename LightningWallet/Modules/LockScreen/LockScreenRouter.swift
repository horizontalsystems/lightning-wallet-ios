import UIKit
import PinKit

class LockScreenRouter {
    weak var viewController: UIViewController?

    private let appStart: Bool

    init(appStart: Bool) {
        self.appStart = appStart
    }

}


extension LockScreenRouter: ILockScreenRouter {

    func dismiss() {
        if appStart {
            UIApplication.shared.keyWindow?.set(newRootController: MainRouter.module())
        } else {
            viewController?.dismiss(animated: false)
        }
    }

}

extension LockScreenRouter {

    static func module(pinKit: IPinKit, appStart: Bool) -> UIViewController {
        let router = LockScreenRouter(appStart: appStart)
        let presenter = LockScreenPresenter(router: router)

        let unlockController = pinKit.unlockPinModule(delegate: presenter, enableBiometry: true, presentationStyle: .simple, cancellable: false)

        router.viewController = unlockController

        unlockController.modalTransitionStyle = .crossDissolve

        return unlockController
    }

}
