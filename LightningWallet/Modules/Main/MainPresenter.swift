import Foundation
import CurrencyKit

class MainPresenter {
    weak var view: IMainView?

    private let interactor: IMainInteractor
    private let router: IMainRouter

    private let viewFactory: IValueFormatterFactory

    init(interactor: IMainInteractor, router: IMainRouter, viewFactory: IValueFormatterFactory) {
        self.viewFactory = viewFactory
        self.interactor = interactor
        self.router = router
    }

}

extension MainPresenter: IMainViewDelegate {

    func onLoad() {
        let balance = Decimal(string: "99.631")
        let rate = Decimal(string: "0.631")
        let currency = interactor.currency

        view?.set(state: .done)
//        view?.set(state: .sync)
        view?.set(coinBalance: viewFactory.coinBalance(balance: balance))
        view?.set(fiatBalance: viewFactory.currencyValue(balance: balance, rate: rate, currency: currency))

        view?.set(progress: 0.13)
    }

    func onDeposit() {
        print("onDeposit")
    }

    func onSend() {
        print("onSend")
    }

    func onChannels() {
        print("onChannels")
    }

    func onSettings() {
        router.openSettings()
    }

    func onTransactions() {
        router.openTransactions()
    }

}
