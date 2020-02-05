import StorageKit

class LaunchInteractor {
    private let keychainKit: IKeychainKit
    private let localStorage: ILocalStorage

    init(keychainKit: IKeychainKit, localStorage: ILocalStorage) {
        self.keychainKit = keychainKit
        self.localStorage = localStorage
    }

}

extension LaunchInteractor: ILaunchInteractor {

    var passcodeLocked: Bool {
        keychainKit.locked
    }

    var isPinSet: Bool {
        true
    }

    var mainShownOnce: Bool {
        localStorage.mainShownOnce
    }

}
