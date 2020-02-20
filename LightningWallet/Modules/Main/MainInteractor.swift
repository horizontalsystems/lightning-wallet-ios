import CurrencyKit
import LightningKit
import RxSwift

class MainInteractor {
    weak var delegate: IMainInteractorDelegate?

    private let lightningKit: LightningKit.Kit
    private let currencyKit: ICurrencyKit

    private let disposeBag = DisposeBag()

    init(lightningKit: LightningKit.Kit, currencyKit: ICurrencyKit) {
        self.lightningKit = lightningKit
        self.currencyKit = currencyKit
    }

}

extension MainInteractor: IMainInteractor {

    var currency: Currency {
        currencyKit.baseCurrency
    }

    func subscribeToStatus() {
        lightningKit.statusObservable
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak self] status in
                    self?.delegate?.didUpdate(status: status)
                })
                .disposed(by: disposeBag)
    }

    func fetchWalletBalance() {
        lightningKit.getWalletBalance()
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
                .observeOn(MainScheduler.instance)
                .subscribe(onSuccess: { [weak self] balance in
                    self?.delegate?.didUpdate(walletBalance: Int(balance.totalBalance))
                })
                .disposed(by: disposeBag)
    }

    func fetchChannelBalance() {
        lightningKit.getChannelBalance()
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
                .observeOn(MainScheduler.instance)
                .subscribe(onSuccess: { [weak self] balance in
                    self?.delegate?.didUpdate(channelBalance: Int(balance.balance))
                })
                .disposed(by: disposeBag)
    }

}
