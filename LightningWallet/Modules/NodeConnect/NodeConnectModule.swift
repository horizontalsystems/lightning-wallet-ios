import LightningKit

protocol INodeConnectRouter {
    func showMain()
}

protocol INodeConnectView: class {
    func show(address: String)
}

protocol INodeConnectViewDelegate {
    func onLoad()
    func onTapConnect()
}

protocol INodeConnectInteractor {
    func validate(credentials: RpcCredentials)
    func saveWallet(credentials: RpcCredentials)
}

protocol INodeConnectInteractorDelegate: AnyObject {
    func didValidateCredentials()
    func didFailToValidateCredentials(error: Error)
}
