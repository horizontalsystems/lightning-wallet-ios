import StorageKit
import PinKit
import CurrencyKit

class App {
    static let shared = App()

    let keychainKit: IKeychainKit
    let pinKit: IPinKit
    let currencyKit: ICurrencyKit

    let keychainKitDelegate: KeychainKitDelegate
    let pinKitDelegate: PinKitDelegate

    let appManager: AppManager

    init() {
        keychainKit = KeychainKit(service: "io.horizontalsystems.lightning")
        pinKit = PinKit.Kit(secureStorage: keychainKit.secureStorage, localStorage: StorageKit.LocalStorage.default)
        currencyKit = CurrencyKit.Kit(localStorage: StorageKit.LocalStorage.default)

        keychainKitDelegate = KeychainKitDelegate()
        keychainKit.set(delegate: keychainKitDelegate)

        pinKitDelegate = PinKitDelegate()
        pinKit.set(delegate: pinKitDelegate)

        appManager = AppManager(keychainKit: keychainKit,
                                pinKit: pinKit
                )
    }

}
