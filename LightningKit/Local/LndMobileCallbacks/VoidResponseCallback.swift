import RxSwift
import Lndmobile

class VoidResponseCallback: NSObject, LndmobileCallbackProtocol {
    private var emitter: ((SingleEvent<Void>) -> Void)?
    
    init(emitter: ((SingleEvent<Void>) -> Void)?) {
        self.emitter = emitter
    }
    
    func onError(_ error: Error?) {
        emitter?(.error(error ?? LndMobileCallbackError.unknownError))
        emitter = nil
    }
    
    func onResponse(_ response: Data?) {
        emitter?(.success(Void()))
        emitter = nil
    }
}
