import StorageKit
import PinKit
import CurrencyKit

class App {
    static let shared = App()

    let keychainKit: IKeychainKit
    let pinKit: IPinKit
    let currencyKit: ICurrencyKit

    let walletStorage: WalletStorage
    let lightningKitManager: LightningKitManager
    let walletManager: WalletManager

    let keychainKitDelegate: KeychainKitDelegate
    let pinKitDelegate: PinKitDelegate

    let appManager: AppManager

    init() {
        keychainKit = KeychainKit(service: "io.horizontalsystems.lightning")
        pinKit = PinKit.Kit(secureStorage: keychainKit.secureStorage, localStorage: StorageKit.LocalStorage.default)
        currencyKit = CurrencyKit.Kit(localStorage: StorageKit.LocalStorage.default)

        walletStorage = WalletStorage(secureStorage: keychainKit.secureStorage)
        lightningKitManager = LightningKitManager()
        walletManager = WalletManager(walletStorage: walletStorage, lightningKitManager: lightningKitManager)

        keychainKitDelegate = KeychainKitDelegate()
        keychainKit.set(delegate: keychainKitDelegate)

        pinKitDelegate = PinKitDelegate()
        pinKit.set(delegate: pinKitDelegate)

        appManager = AppManager(
                keychainKit: keychainKit,
                pinKit: pinKit,
                walletManager: walletManager
        )
    }

}
