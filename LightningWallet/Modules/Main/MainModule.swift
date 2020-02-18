import Foundation
import CurrencyKit

protocol IMainRouter {
    func openSettings()
    func openTransactions()
    func openChannels()
}

protocol IMainView: class {
    func set(state: MainState)
    func set(progress: Double)
    func set(coinBalance: String?)
    func set(fiatBalance: String?)
}

protocol IMainViewDelegate {
    func onLoad()
    func onDeposit()
    func onSend()
    func onChannels()
    func onSettings()
    func onTransactions()
}

protocol IMainInteractor {
    var currency: Currency { get }
}

enum MainState {
    case sync
    case done
}
