import RxSwift

protocol IAppManager {
    var didBecomeActiveObservable: Observable<()> { get }
    var willEnterForegroundObservable: Observable<()> { get }
}

protocol ILocalStorage: class {
}

protocol IBiometryManager {
    var biometryType: BiometryType { get }
    var biometryTypeObservable: Observable<BiometryType> { get }
    func refresh()
}

protocol ISystemInfoManager {
    var biometryType: Single<BiometryType> { get }
}
