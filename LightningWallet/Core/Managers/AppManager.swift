import RxSwift
import StorageKit
import PinKit

class AppManager {
    private let keychainKit: IKeychainKit
    private let pinKit: IPinKit

    private let didBecomeActiveSubject = PublishSubject<()>()
    private let willEnterForegroundSubject = PublishSubject<()>()

    init(keychainKit: IKeychainKit, pinKit: IPinKit) {
        self.keychainKit = keychainKit
        self.pinKit = pinKit
    }

}

extension AppManager {

    func didFinishLaunching() {
        keychainKit.handleLaunch()
        pinKit.didFinishLaunching()
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
