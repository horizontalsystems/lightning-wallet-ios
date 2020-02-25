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
    private var status: NodeStatus = .connecting

    init(interactor: IMainInteractor, router: IMainRouter, viewFactory: IValueFormatterFactory) {
        self.viewFactory = viewFactory
        self.interactor = interactor
        self.router = router
    }

    private func syncBalanceView() {
        if (status == .syncing || status == .running), let walletBalance = walletBalance, let channelBalance = channelBalance {
            let totalBalance = walletBalance + channelBalance
            view?.show(totalBalance: totalBalance)
        } else {
            view?.hideTotalBalance()
        }
    }

    private func syncUnlockButton() {
        view?.setUnlockButton(visible: status == .locked)
    }

    private func syncLightningButtons() {
        view?.setLightningButtons(enabled: status == .syncing || status == .running)
    }

    private func syncControls() {
        switch status {
        case .connecting:
            view?.showConnectingStatus()
        case .syncing:
            view?.showSyncingStatus()
        case .error(let error):
            view?.showErrorStatus(error: error)
        case .running:
            view?.hideStatus()
        case .unlocking:
            view?.showUnlockingStatus()
        case .locked:
            view?.showLockedStatus()
        }

        syncBalanceView()
        syncLightningButtons()
        syncUnlockButton()
    }

}

extension MainPresenter: IMainViewDelegate {

    func onLoad() {
        syncControls()

        interactor.subscribeToStatus()
        interactor.subscribeToWalletBalance()
        interactor.subscribeToChannelBalance()
    }

    func onTapUnlock() {
        router.showUnlock()
    }

    func onTapDeposit() {
        print("onDeposit")
    }

    func onTapSend() {
        print("onSend")
    }

    func onTapChannels() {
        router.openChannels()
    }

    func onTapSettings() {
        router.openSettings()
    }

    func onTapTransactions() {
        router.openTransactions()
    }

}

extension MainPresenter: IMainInteractorDelegate {

    func didUpdate(status: NodeStatus) {
        self.status = status
        syncControls()

        if status == .running || status == .syncing {
            interactor.fetchWalletBalance()
            interactor.fetchChannelBalance()
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
