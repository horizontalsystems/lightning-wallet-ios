class LaunchPresenter {
    private let interactor: ILaunchInteractor

    init(interactor: ILaunchInteractor) {
        self.interactor = interactor
    }

}

extension LaunchPresenter: ILaunchPresenter {

    var launchMode: LaunchMode {
        if !interactor.mainShownOnce {
            return  .welcome
        } else {
            return .main
        }
    }

}
