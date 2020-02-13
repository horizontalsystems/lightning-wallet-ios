import CurrencyKit

class MainInteractor {
    private let currencyKit: ICurrencyKit

    init(currencyKit: ICurrencyKit) {
        self.currencyKit = currencyKit
    }

}

extension MainInteractor: IMainInteractor {

    var currency: Currency {
        currencyKit.baseCurrency
    }

}
