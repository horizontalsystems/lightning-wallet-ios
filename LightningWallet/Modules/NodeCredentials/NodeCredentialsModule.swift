import LightningKit

protocol INodeCredentialsRouter {
    func openConnectNode(credentials: RpcCredentials)
}

protocol INodeCredentialsView: class {
    func showDescription()
    func showEmptyPasteboard()
    func showError()
    func notifyScan()
    func stopScan()
}

protocol INodeCredentialsViewDelegate {
    func onLoad()

    func onPaste()
    func onScan(string: String)
}

protocol INodeCredentialsInteractor {
    var pasteboard: String? { get }
    func credentials(urlString: String) -> RpcCredentials?
}

protocol INodeCredentialsInteractorDelegate: class {
}

protocol INotificationTimer {
    func start(interval: TimeInterval)
}

protocol INotificationTimerDelegate: class {
    func onFire()
}

enum NodeCredentialsParsing: Error {
    case emptyData
    case wrongData
}