import UIKit

class NodeCredentialsInteractor {
    weak var delegate: INodeCredentialsInteractorDelegate?

    init() {
    }

}

extension NodeCredentialsInteractor: INodeCredentialsInteractor {

    var pasteboard: String? {
        UIPasteboard.general.string
    }

    func parse(code: String?) throws -> String {
        guard let code = code else {
            throw NodeCredentialsParsing.emptyData
        }
        return code
//        throw NodeCredentialsParsing.wrongData
    }

}