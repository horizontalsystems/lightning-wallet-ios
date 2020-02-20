import Foundation
import CurrencyKit
import LightningKit

class MainPresenter {
    weak var view: IMainView?

    private let interactor: IMainInteractor
    private let router: IMainRouter

    private let viewFactory: IValueFormatterFactory

    private var walletBalance: Int?
    private var channelBalance: Int?

    init(interactor: IMainInteractor, router: IMainRouter, viewFactory: IValueFormatterFactory) {
        self.viewFactory = viewFactory
        self.interactor = interactor
        self.router = router
    }

    private func syncBalanceView() {
        if let walletBalance = walletBalance, let channelBalance = channelBalance {
            let totalBalance = walletBalance + channelBalance
            view?.show(totalBalance: totalBalance)
        } else {
            // todo
        }
    }

}

extension MainPresenter: IMainViewDelegate {

    func onLoad() {
        view?.showConnectingStatus() // todo: remove this by getting status via single when implemented in kit
        interactor.subscribeToStatus()

        interactor.fetchWalletBalance()
        interactor.fetchChannelBalance()
    }

    func onDeposit() {
        print("onDeposit")
    }

    func onSend() {
        print("onSend")
    }

    func onChannels() {
        router.openChannels()
    }

    func onSettings() {
        router.openSettings()
    }

    func onTransactions() {
        router.openTransactions()
    }

}

extension MainPresenter: IMainInteractorDelegate {

    func didUpdate(status: NodeStatus) {
        switch status {
        case .connecting:
            view?.showConnectingStatus()
        case .syncing:
            view?.showSyncingStatus()
        case .error(let error):
            view?.showErrorStatus(error: error)
        case .running:
            view?.hideStatus()
        default:
            // todo: handle .locked and .unlocking statuses
            view?.hideStatus()
        }
    }

    func didUpdate(walletBalance: Int) {
        self.walletBalance = walletBalance
        syncBalanceView()
    }

    func didUpdate(channelBalance: Int) {
        self.channelBalance = channelBalance
        syncBalanceView()
    }

}
