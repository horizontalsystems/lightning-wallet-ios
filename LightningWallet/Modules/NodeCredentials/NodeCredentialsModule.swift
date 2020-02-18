import LightningKit

protocol INodeCredentialsRouter {
    func openConnectNode(credentials: RpcCredentials)
}

protocol INodeCredentialsView: class {
    func showDescription()
    func showError()
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

enum NodeCredentialsParsing: Error {
    case emptyData
    case wrongData
}