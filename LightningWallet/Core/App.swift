import StorageKit
import PinKit

class App {
    static let shared = App()

    let keychainKit: IKeychainKit
    let pinKit: IPinKit

    let localStorage: ILocalStorage
    let keychainKitDelegate: KeychainKitDelegate
    let pinKitDelegate: PinKitDelegate

    let appManager: AppManager

    let systemInfoManager: ISystemInfoManager
    let biometryManager: IBiometryManager

    init() {
        keychainKit = KeychainKit(service: "io.horizontalsystems.lightning")

        localStorage = LocalStorage(storage: StorageKit.LocalStorage.default)

        pinKit = PinKit.Kit(secureStorage: keychainKit.secureStorage, localStorage: StorageKit.LocalStorage.default)

        systemInfoManager = SystemInfoManager()
        biometryManager = BiometryManager(systemInfoManager: systemInfoManager)

        keychainKitDelegate = KeychainKitDelegate()
        keychainKit.set(delegate: keychainKitDelegate)

        pinKitDelegate = PinKitDelegate()
        pinKit.set(delegate: pinKitDelegate)

        appManager = AppManager(keychainKit: keychainKit,
                                pinKit: pinKit,
                                biometryManager: biometryManager
                )
    }

}
