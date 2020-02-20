import RxSwift
import Lndmobile

class VoidResponseCallback: NSObject, LndmobileCallbackProtocol {
    private let emitter: (SingleEvent<Void>) -> Void
    
    init(emitter: @escaping (SingleEvent<Void>) -> Void) {
        self.emitter = emitter
    }
    
    func onError(_ error: Error?) {
<<<<<<< HEAD
//        print("VoidResponseCallback error :\(error)")
=======
>>>>>>> Rename(or make parameter) methods to comply code convention
        emitter(.error(error ?? LndMobileCallbackError.unknownError))
    }
    
    func onResponse(_ response: Data?) {
<<<<<<< HEAD
//        print("VoidResponseCallback response :\(response)")
=======
>>>>>>> Rename(or make parameter) methods to comply code convention
        emitter(.success(Void()))
    }
}
