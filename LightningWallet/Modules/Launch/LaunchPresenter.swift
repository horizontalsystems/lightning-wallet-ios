import LightningKit

class LaunchPresenter {
    private let interactor: ILaunchInteractor

    init(interactor: ILaunchInteractor) {
        self.interactor = interactor
    }

}

extension LaunchPresenter: ILaunchPresenter {

    var launchMode: LaunchMode {
        if interactor.passcodeLocked {
            return .noPasscode
        } else if interactor.isPinSet {
            return .unlock
        } else if interactor.hasStoredWallet {
            return .main
        } else {
            return .welcome
        }
    }

}
