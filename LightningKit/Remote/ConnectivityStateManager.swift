import GRPC
import RxSwift

class ConnectivityStateManager: ConnectivityStateDelegate {
    weak var listener: ConnectivityStateListener?
    
    func connectivityStateDidChange(from oldState: ConnectivityState, to newState: ConnectivityState) {
        listener?.connectivityStateDidChange(to: newState)
    }
}

protocol ConnectivityStateListener: AnyObject {
    func connectivityStateDidChange(to newState: ConnectivityState)
}
