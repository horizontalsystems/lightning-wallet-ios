import StorageKit
import PinKit

class LaunchInteractor {
    private let keychainKit: IKeychainKit
    private let pinKit: IPinKit
    private let walletManager: WalletManager

    init(keychainKit: IKeychainKit, pinKit: IPinKit, walletManager: WalletManager) {
        self.keychainKit = keychainKit
        self.pinKit = pinKit
        self.walletManager = walletManager
    }

}

extension LaunchInteractor: ILaunchInteractor {

    var passcodeLocked: Bool {
        keychainKit.locked
    }

    var isPinSet: Bool {
        pinKit.isPinSet
    }

    var hasStoredWallet: Bool {
        walletManager.hasStoredWallet
    }

}
