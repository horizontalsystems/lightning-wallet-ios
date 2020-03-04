import Lndmobile

class RpcReadyCallback: NSObject, LndmobileCallbackProtocol {
    private weak var delegate: RpcReadyCallbackDelegate?
    
    init(_ delegate: RpcReadyCallbackDelegate?) {
        self.delegate = delegate
    }
    
    func onError(_ error: Error?) {
        delegate?.RpcServerStartFailed(error: error ?? LndMobileCallbackError.unknownError)
    }
    
    func onResponse(_ response: Data?) {
        delegate?.rpcReady()
    }
}

protocol RpcReadyCallbackDelegate: AnyObject {
    func RpcServerStartFailed(error: Error)
    func rpcReady()
}
