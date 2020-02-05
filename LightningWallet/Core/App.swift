import StorageKit

class App {
    static let shared = App()

    let keychainKit: IKeychainKit

    let localStorage: ILocalStorage
    let keychainKitDelegate: KeychainKitDelegate

    let appManager: AppManager

    init() {
        keychainKit = KeychainKit(service: "io.horizontalsystems.lightning")

        localStorage = LocalStorage(storage: StorageKit.LocalStorage.default)

        keychainKitDelegate = KeychainKitDelegate()
        keychainKit.set(delegate: keychainKitDelegate)

        appManager = AppManager(keychainKit: keychainKit)
    }

}
