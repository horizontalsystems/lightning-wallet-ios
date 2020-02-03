class LaunchInteractor {
    private let localStorage: ILocalStorage

    init(localStorage: ILocalStorage) {
        self.localStorage = localStorage
    }

}

extension LaunchInteractor: ILaunchInteractor {

    var passcodeLocked: Bool {
        false
    }

    var isPinSet: Bool {
        true
    }

    var mainShownOnce: Bool {
        localStorage.mainShownOnce
    }

}
