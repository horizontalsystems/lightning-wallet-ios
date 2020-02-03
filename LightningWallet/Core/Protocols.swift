import RxSwift

protocol IAppManager {
    var didBecomeActiveObservable: Observable<()> { get }
    var willEnterForegroundObservable: Observable<()> { get }
}

protocol ILocalStorage: class {
    var mainShownOnce: Bool { get set }
}
