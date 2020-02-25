import RxSwift
import Lndmobile

class VoidResponseCallback: NSObject, LndmobileCallbackProtocol {
    private let emitter: ((SingleEvent<Void>) -> Void)?
    
    init(emitter: ((SingleEvent<Void>) -> Void)?) {
        self.emitter = emitter
    }
    
    func onError(_ error: Error?) {
        emitter?(.error(error ?? LndMobileCallbackError.unknownError))
    }
    
    func onResponse(_ response: Data?) {
        emitter?(.success(Void()))
    }
}
