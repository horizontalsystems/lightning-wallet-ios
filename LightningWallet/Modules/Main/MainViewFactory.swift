import Foundation
import CurrencyKit

class MainViewFactory {

    private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()

}

extension MainViewFactory: IMainViewFactory {

    func currencyValue(balance: Decimal?, rate: Decimal?, currency: Currency) -> String? {
        guard let balance = balance, let rate = rate else {
            return nil
        }

        currencyFormatter.currencyCode = currency.code
        currencyFormatter.currencySymbol = currency.symbol

        return currencyFormatter.string(from: balance * rate as NSNumber)
    }

    func coinBalance(balance: Decimal?) -> String? {
        guard let balance = balance else {
            return nil
        }

        return "\(balance) sat"
    }

}
