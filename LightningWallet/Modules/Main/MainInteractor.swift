import CurrencyKit
import LightningKit

class MainInteractor {
    private let lightningKit: LightningKit.Kit
    private let currencyKit: ICurrencyKit

    init(lightningKit: LightningKit.Kit, currencyKit: ICurrencyKit) {
        self.lightningKit = lightningKit
        self.currencyKit = currencyKit
    }

}

extension MainInteractor: IMainInteractor {

    var currency: Currency {
        currencyKit.baseCurrency
    }

}
