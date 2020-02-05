protocol ILaunchInteractor {
    var passcodeLocked: Bool { get }
    var mainShownOnce: Bool { get }
}

protocol ILaunchPresenter {
    var launchMode: LaunchMode { get }
}

enum LaunchMode {
    case noPasscode
    case welcome
    case main
}
