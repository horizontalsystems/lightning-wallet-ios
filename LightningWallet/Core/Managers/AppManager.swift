import RxSwift
import StorageKit

class AppManager {
    private let keychainKit: IKeychainKit

    private let didBecomeActiveSubject = PublishSubject<()>()
    private let willEnterForegroundSubject = PublishSubject<()>()

    init(keychainKit: IKeychainKit) {
        self.keychainKit = keychainKit
    }

}

extension AppManager {

    func didFinishLaunching() {
        keychainKit.handleLaunch()
    }

    func willResignActive() {
    }

    func didBecomeActive() {
    }

    func didEnterBackground() {
    }

    func willEnterForeground() {
        keychainKit.handleForeground()
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
