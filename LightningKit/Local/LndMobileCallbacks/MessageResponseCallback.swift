import RxSwift
import Lndmobile
import SwiftProtobuf

class MessageResponseCallback<T:Message>: NSObject, LndmobileCallbackProtocol {
    private let emitter: (SingleEvent<T>) -> Void
    
    init(emitter: @escaping (SingleEvent<T>) -> Void) {
        self.emitter = emitter
    }
    
    func onError(_ error: Error?) {
        emitter(.error(error ?? LndMobileCallbackError.unknownError))
    }
    
    func onResponse(_ response: Data?) {
        guard let responseData = response else {
            emitter(.success(T()))
            return
        }
        
        guard let responseMessage = try? T(serializedData: responseData) else {
            emitter(.error(LndMobileCallbackError.responseCannotBeDecoded))
            return
        }
        
        emitter(.success(responseMessage))
    }
}
