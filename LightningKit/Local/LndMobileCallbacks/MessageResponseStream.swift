import Lndmobile
import RxSwift
import SwiftProtobuf

class MessageResponseStream<T:Message>: NSObject, LndmobileRecvStreamProtocol {
    private let emitter: AnyObserver<T>


    init(emitter: AnyObserver<T>) {
        self.emitter = emitter
    }

    func onError(_ error: Error?) {
        emitter.onError(error ?? LndMobileCallbackError.unknownError)
    }

    func onResponse(_ response: Data?) {
        guard let responseData = response else {
            emitter.onNext(T())
            return
        }
        
        guard let responseMessage = try? T(serializedData: responseData) else {
            emitter.onError(LndMobileCallbackError.responseCannotBeDecoded)
            return
        }
        
        emitter.onNext(responseMessage)
    }
}
