import LightningKit
import RxSwift

class UnlockRemoteWalletInteractor {
    weak var delegate: IUnlockRemoteWalletInteractorDelegate?

    private let lightningKit: LightningKit.Kit

    private let disposeBag = DisposeBag()

    init(lightningKit: LightningKit.Kit) {
        self.lightningKit = lightningKit
    }

}

extension UnlockRemoteWalletInteractor: IUnlockRemoteWalletInteractor {

    func unlockWallet(password: String) {
        lightningKit.unlockWalletSingle(password: Data(Array(password.utf8)))
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
                .observeOn(MainScheduler.instance)
                .subscribe(onSuccess: { [weak self] in
                    self?.delegate?.didUnlockWallet()
                }, onError: { [weak self] error in
                    self?.delegate?.didFailToUnlockWallet(error: error)
                })
                .disposed(by: disposeBag)
    }

}
