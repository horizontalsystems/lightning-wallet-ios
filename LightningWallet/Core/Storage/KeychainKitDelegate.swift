import UIKit
import StorageKit

class KeychainKitDelegate {

    private func show(viewController: UIViewController) {
        UIApplication.shared.keyWindow?.set(newRootController: viewController)
    }

}

extension KeychainKitDelegate: IKeychainKitDelegate {

    func onInitialLock() {
    }

    public func onLock() {
        show(viewController: NoPasscodeViewController())
    }

    public func onUnlock() {
        show(viewController: LaunchRouter.module())
    }

}
