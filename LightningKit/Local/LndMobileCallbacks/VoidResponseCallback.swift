import RxSwift
import Lndmobile

class VoidResponseCallback: NSObject, LndmobileCallbackProtocol {
    private let emitter: (SingleEvent<Void>) -> Void
    
    init(emitter: @escaping (SingleEvent<Void>) -> Void) {
        self.emitter = emitter
    }
    
    func onError(_ error: Error?) {
//        print("VoidResponseCallback error :\(error)")
        emitter(.error(error ?? LndMobileCallbackError.unknownError))
    }
    
    func onResponse(_ response: Data?) {
//        print("VoidResponseCallback response :\(response)")
        emitter(.success(Void()))
    }
}
