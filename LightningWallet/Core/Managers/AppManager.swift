import RxSwift

class AppManager {
    private let didBecomeActiveSubject = PublishSubject<()>()
    private let willEnterForegroundSubject = PublishSubject<()>()

    init() {
    }

}

extension AppManager {

    func didFinishLaunching() {
    }

    func willResignActive() {
    }

    func didBecomeActive() {
    }

    func didEnterBackground() {
    }

    func willEnterForeground() {
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
