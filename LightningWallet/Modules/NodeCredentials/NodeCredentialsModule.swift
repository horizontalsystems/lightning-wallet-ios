import Foundation

protocol INodeCredentialsRouter {
    func openConnectNode(someData: String)
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
    func parse(code: String?) throws -> String
}

protocol INodeCredentialsInteractorDelegate: class {
}

enum NodeCredentialsParsing: Error {
    case emptyData
    case wrongData
}