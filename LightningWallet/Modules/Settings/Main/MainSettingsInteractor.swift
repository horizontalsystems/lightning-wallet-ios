import RxSwift
import LanguageKit
import ThemeKit
import CurrencyKit

class MainSettingsInteractor {
    private let disposeBag = DisposeBag()

    weak var delegate: IMainSettingsInteractorDelegate?

    private let themeManager: ThemeManager
    private let currencyKit: ICurrencyKit

    init(themeManager: ThemeManager, currencyKit: ICurrencyKit) {
        self.themeManager = themeManager
        self.currencyKit = currencyKit

        currencyKit.baseCurrencyUpdatedObservable
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak self] _ in
                    self?.delegate?.didUpdateBaseCurrency()
                })
                .disposed(by: disposeBag)
    }

}

extension MainSettingsInteractor: IMainSettingsInteractor {

    var companyWebPageLink: String {
        "companyWebPageLink"
    }

    var appWebPageLink: String {
        "appWebPageLink"
    }

    var currentLanguageDisplayName: String? {
        LanguageManager.shared.currentLanguageDisplayName
    }

    var baseCurrency: Currency {
        currencyKit.baseCurrency
    }

    var lightMode: Bool {
        get {
            themeManager.lightMode
        }
        set {
            themeManager.lightMode = newValue
        }
    }

    var appVersion: String {
        "0.1"
    }

}
