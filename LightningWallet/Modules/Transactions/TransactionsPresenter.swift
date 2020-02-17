class TransactionsPresenter {
    weak var view: ITransactionsView?

    private let router: ITransactionsRouter

    private let factory: IMainViewFactory

    init(router: ITransactionsRouter, factory: IMainViewFactory) {
        self.router = router
        self.factory = factory
    }

}

extension TransactionsPresenter: ITransactionsViewDelegate {

    func onLoad() {
        view?.set(balance: factory.coinBalance(balance: 99.637))
    }

    func onDeposit() {
        print("onDeposit")
    }

    func onSend() {
        print("onSend")
    }

    func onMain() {
        router.dismiss()
    }

    func onChannels() {
        print("onChannels")
    }

    func onSettings() {
        print("onSettings")
    }

}
