import RxSwift
import StorageKit
import PinKit

class AppManager {
    private let keychainKit: IKeychainKit
    private let pinKit: IPinKit
    private let walletManager: WalletManager

    private let didBecomeActiveSubject = PublishSubject<()>()
    private let willEnterForegroundSubject = PublishSubject<()>()

    init(keychainKit: IKeychainKit, pinKit: IPinKit, walletManager: WalletManager) {
        self.keychainKit = keychainKit
        self.pinKit = pinKit
        self.walletManager = walletManager
    }

}

extension AppManager {

    func didFinishLaunching() {
        keychainKit.handleLaunch()
        pinKit.didFinishLaunching()
        walletManager.bootstrapStoredWallet()
    }

    func willResignActive() {
    }

    func didBecomeActive() {
    }

    func didEnterBackground() {
        pinKit.didEnterBackground()
    }

    func willEnterForeground() {
        keychainKit.handleForeground()
        pinKit.willEnterForeground()
    }

    func willTerminate() {
    }

}

extension AppManager: IAppManager {

    var didBecomeActiveObservable: Observable<()> {
        didBecomeActiveSubject.asObservable()
    }

    var willEnterForegroundObservable: Observable<()> {
        willEnterForegroundSubject.asObservable()
    }

}
