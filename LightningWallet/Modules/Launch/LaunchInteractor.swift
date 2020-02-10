import StorageKit
import PinKit

class LaunchInteractor {
    private let keychainKit: IKeychainKit
    private let pinKit: IPinKit

    init(keychainKit: IKeychainKit, pinKit: IPinKit) {
        self.keychainKit = keychainKit
        self.pinKit = pinKit
    }

}

extension LaunchInteractor: ILaunchInteractor {

    var passcodeLocked: Bool {
        keychainKit.locked
    }

    var isPinSet: Bool {
        pinKit.isPinSet
    }

    var loggedIn: Bool {
        keychainKit.secureStorage.value(for: "logged_in") ?? false
    }

}
