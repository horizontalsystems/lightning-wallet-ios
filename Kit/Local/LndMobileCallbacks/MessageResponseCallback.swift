import RxSwift
import Lndmobile
import SwiftProtobuf

class MessageResponseCallback<T:Message>: NSObject, LndmobileCallbackProtocol {    
    private let emitter: (SingleEvent<T>) -> Void
    
    init(emitter: @escaping (SingleEvent<T>) -> Void) {
        self.emitter = emitter
    }
    
    func onError(_ error: Error?) {
        print("MessageResponseCallback error :\(error)")
        emitter(.error(error ?? LndMobileCallbackError.unknownError))
    }
    
    func onResponse(_ response: Data?) {
        print("MessageResponseCallback response :\(response)")
        guard let responseData = response, let responseMessage = try? T(serializedData: responseData) else {
            emitter(.error(LndMobileCallbackError.responseCannotBeDecoded))
            return
        }
        
        emitter(.success(responseMessage))
    }
}
