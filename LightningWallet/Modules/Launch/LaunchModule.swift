protocol ILaunchInteractor {
    var passcodeLocked: Bool { get }
    var loggedIn: Bool { get }
}

protocol ILaunchPresenter {
    var launchMode: LaunchMode { get }
}

enum LaunchMode {
    case noPasscode
    case welcome
    case main
}
