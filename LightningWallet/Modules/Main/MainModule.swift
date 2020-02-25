import Foundation
import CurrencyKit
import LightningKit

protocol IMainRouter {
    func openSettings()
    func openTransactions()
    func openChannels()
    func showUnlock()
}

protocol IMainView: class {
    func showConnectingStatus()
    func showSyncingStatus()
    func showUnlockingStatus()
    func showLockedStatus()
    func showErrorStatus(error: Error)
    func hideStatus()

    func setUnlockButton(visible: Bool)

    func show(totalBalance: Int)
    func hideTotalBalance()

    func setLightningButtons(enabled: Bool)
}

protocol IMainViewDelegate {
    func onLoad()
    func onTapUnlock()
    func onTapDeposit()
    func onTapSend()
    func onTapChannels()
    func onTapSettings()
    func onTapTransactions()
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
