class App {
    static let shared = App()

    let localStorage: ILocalStorage
    let appManager: AppManager

    init() {
        localStorage = UserDefaultsStorage()
        appManager = AppManager()
    }

}
