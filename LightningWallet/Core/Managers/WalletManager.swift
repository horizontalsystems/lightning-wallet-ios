import LightningKit

class WalletManager {
    private let walletStorage: WalletStorage
    private let lightningKitManager: LightningKitManager

    init(walletStorage: WalletStorage, lightningKitManager: LightningKitManager) {
        self.walletStorage = walletStorage
        self.lightningKitManager = lightningKitManager
    }

    var hasStoredWallet: Bool {
        walletStorage.storedWallet != nil
    }

    func bootstrapStoredWallet() {
        if let wallet = walletStorage.storedWallet {
            lightningKitManager.loadKit(connection: wallet.connection)
        }
    }

    func saveAndBootstrapRemoteWallet(credentials: RpcCredentials) {
        let connection: LightningConnection = .remote(credentials: credentials)
        let wallet = Wallet(connection: connection)

        walletStorage.storedWallet = wallet
        lightningKitManager.loadKit(connection: connection)
    }

    func removeStoredWallet() {
        walletStorage.storedWallet = nil
        lightningKitManager.unloadKit()
    }

}
