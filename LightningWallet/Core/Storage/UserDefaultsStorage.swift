import Foundation

class UserDefaultsStorage {
    private let keyMainShownOnceKey = "main_shown_once"

    private func value<T>(for key: String) -> T? {
        UserDefaults.standard.value(forKey: key) as? T
    }

    private func set<T>(value: T?, for key: String) {
        if let value = value {
            UserDefaults.standard.set(value, forKey: key)
        } else  {
            UserDefaults.standard.removeObject(forKey: key)
        }
        UserDefaults.standard.synchronize()
    }

}

extension UserDefaultsStorage: ILocalStorage {

    var mainShownOnce: Bool {
        get { value(for: keyMainShownOnceKey) ?? false }
        set { set(value: newValue, for: keyMainShownOnceKey) }
    }

}
