protocol ILaunchInteractor {
    var mainShownOnce: Bool { get }
}

protocol ILaunchPresenter {
    var launchMode: LaunchMode { get }
}

enum LaunchMode {
    case welcome
    case main
}
