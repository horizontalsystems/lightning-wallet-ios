import RxSwift
import Lndmobile
import SwiftProtobuf

class MessageResponseCallback<T:Message>: NSObject, LndmobileCallbackProtocol {
    private var emitter: ((SingleEvent<T>) -> Void)?
    
    init(emitter: @escaping (SingleEvent<T>) -> Void) {
        self.emitter = emitter
    }
    
    func onError(_ error: Error?) {
        emitter?(.error(error ?? LndMobileCallbackError.unknownError))
    }
    
    func onResponse(_ response: Data?) {
        guard let responseData = response else {
            emitter?(.success(T()))
            emitter = nil
            return
        }
        
        guard let responseMessage = try? T(serializedData: responseData) else {
            emitter?(.error(LndMobileCallbackError.responseCannotBeDecoded))
            emitter = nil
            return
        }
        
        emitter?(.success(responseMessage))
        emitter = nil
    }
}
