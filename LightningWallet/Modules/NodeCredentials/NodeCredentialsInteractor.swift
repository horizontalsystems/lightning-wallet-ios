import UIKit
import LightningKit

class NodeCredentialsInteractor {
    weak var delegate: INodeCredentialsInteractorDelegate?

    init() {
    }

}

extension NodeCredentialsInteractor: INodeCredentialsInteractor {

    var pasteboard: String? {
        UIPasteboard.general.string
    }

    func credentials(urlString: String) -> RpcCredentials? {
        RpcCredentials(lndConnectUrlString: urlString)
    }

}