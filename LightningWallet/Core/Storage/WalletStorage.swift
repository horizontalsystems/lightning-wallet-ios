import StorageKit

class WalletStorage {
    private static let keyWallet = "wallet"

    private let secureStorage: ISecureStorage

    init(secureStorage: ISecureStorage) {
        self.secureStorage = secureStorage
    }

    var storedWallet: Wallet? {
        get {
            guard let data: Data = secureStorage.value(for: WalletStorage.keyWallet) else {
                return nil
            }

            return try? JSONDecoder().decode(Wallet.self, from: data)
        }
        set {
            if let newValue = newValue {
                guard let data = try? JSONEncoder().encode(newValue) else {
                    // TODO: need to decide if we should remove value from keychain if encoding failed
                    return
                }

                try? secureStorage.set(value: data, for: WalletStorage.keyWallet)
            } else {
                try? secureStorage.removeValue(for: WalletStorage.keyWallet)
            }
        }
    }

}
