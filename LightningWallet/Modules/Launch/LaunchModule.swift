protocol ILaunchInteractor {
    var passcodeLocked: Bool { get }
    var isPinSet: Bool { get }
    var loggedIn: Bool { get }
}

protocol ILaunchPresenter {
    var launchMode: LaunchMode { get }
}

enum LaunchMode {
    case noPasscode
    case welcome
    case unlock
    case main
}
