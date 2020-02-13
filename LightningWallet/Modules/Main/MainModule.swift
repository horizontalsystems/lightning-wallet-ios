import Foundation
import CurrencyKit

protocol IMainRouter {
    func openSettings()
    func openTransactions()
}

protocol IMainView: class {
    func set(state: MainState)
    func set(progress: Double)
    func set(coinBalance: String?)
    func set(fiatBalance: String?)
}

protocol IMainViewDelegate {
    func didLoad()
    func onDeposit()
    func onSend()
    func onChannels()
    func onSettings()
    func onTransactions()
}

protocol IMainInteractor {
    var currency: Currency { get }
}

protocol IMainViewFactory {
    func currencyValue(balance: Decimal?, rate: Decimal?, currency: Currency) -> String?
    func coinBalance(balance: Decimal?) -> String?
}

enum MainState {
    case sync
    case done
}
