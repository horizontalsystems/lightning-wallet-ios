import Foundation
import CurrencyKit
import LightningKit

protocol IMainRouter {
    func openSettings()
    func openTransactions()
    func openChannels()
}

protocol IMainView: class {
    func showConnectingStatus()
    func showSyncingStatus()
    func showErrorStatus(error: Error)
    func hideStatus()

    func show(totalBalance: Int)
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

    func subscribeToStatus()
    func fetchWalletBalance()
    func fetchChannelBalance()
    func subscribeToWalletBalance()
    func subscribeToChannelBalance()
}

protocol IMainInteractorDelegate: AnyObject {
    func didUpdate(status: NodeStatus)
    func didUpdate(walletBalance: Int)
    func didUpdate(channelBalance: Int)
}

enum MainState {
    case sync
    case done
}
