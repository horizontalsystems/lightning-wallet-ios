import GRPC
import RxSwift

class ConnectivityManager {
    private var available: Bool? = nil
    private var onAvailabilityChangeCallback: ((Bool) -> Void)?

    private var availabilitySingle: Single<Bool> {
        Single.create { [weak self] emitter in
            self?.onAvailabilityChangeCallback = { emitter(.success($0)) }
            return Disposables.create()
        }.do(onDispose: { [weak self] in
            self?.onAvailabilityChangeCallback = nil
        })
    }
    
    var isConnected: Bool {
        available ?? false
    }

    func runIfConnected<T>(_ callFunction: @escaping () -> Single<T>) -> Single<T> {
        guard let available = self.available else {
            // Here, the availability is unknown, that is, the connection establishment is not completed yet.
            // So, we wait until it completes and we learn wether the connection is established or an error has occured.
            
            return availabilitySingle.flatMap { available in
                available
                    ? callFunction()
                    : Single.error(GRPCStatus(code: .unavailable, message: "Not connected to remote node"))
            }
        }
        
        return available
            ? callFunction()
            : Single.error(GRPCStatus(code: .unavailable, message: "Not connected to remote node"))
    }
}

extension ConnectivityManager: ConnectivityStateDelegate {
    func connectivityStateDidChange(from oldState: ConnectivityState, to newState: ConnectivityState) {
        if newState == .ready {
            available = true
            onAvailabilityChangeCallback?(true)
        } else if newState == .transientFailure {
            available = false
            onAvailabilityChangeCallback?(false)
        }
    }
}
