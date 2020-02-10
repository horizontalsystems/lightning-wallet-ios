import RxSwift
import StorageKit
import PinKit

class AppManager {
    private let keychainKit: IKeychainKit
    private let pinKit: IPinKit
    private let biometryManager: IBiometryManager

    private let didBecomeActiveSubject = PublishSubject<()>()
    private let willEnterForegroundSubject = PublishSubject<()>()

    init(keychainKit: IKeychainKit, pinKit: IPinKit, biometryManager: IBiometryManager) {
        self.keychainKit = keychainKit
        self.pinKit = pinKit
        self.biometryManager = biometryManager
    }

}

extension AppManager {

    func didFinishLaunching() {
        keychainKit.handleLaunch()
        biometryManager.refresh()
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
        biometryManager.refresh()
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
