import StorageKit

class LaunchInteractor {
    private let keychainKit: IKeychainKit

    init(keychainKit: IKeychainKit) {
        self.keychainKit = keychainKit
    }

}

extension LaunchInteractor: ILaunchInteractor {

    var passcodeLocked: Bool {
        keychainKit.locked
    }

    var isPinSet: Bool {
        true
    }

    var loggedIn: Bool {
        keychainKit.secureStorage.value(for: "logged_in") ?? false
    }

}
