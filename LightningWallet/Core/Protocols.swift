import RxSwift
import CurrencyKit

protocol IAppManager {
    var didBecomeActiveObservable: Observable<()> { get }
    var willEnterForegroundObservable: Observable<()> { get }
}

protocol ILocalStorage: class {
}

protocol IValueFormatterFactory {
    func currencyValue(balance: Decimal?, rate: Decimal?, currency: Currency) -> String?
    func coinBalance(balance: Decimal?) -> String?
}
