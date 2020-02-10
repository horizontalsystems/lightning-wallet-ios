import StorageKit

class LocalStorage {
    private let storage: StorageKit.ILocalStorage

    init(storage: StorageKit.ILocalStorage) {
        self.storage = storage
    }

}

extension LocalStorage: ILocalStorage {
}
