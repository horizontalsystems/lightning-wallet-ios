import UIKit
import ThemeKit
import LightningKit

class NodeCredentialsRouter {
    weak var viewController: UIViewController?
}

extension NodeCredentialsRouter: INodeCredentialsRouter {

    func openConnectNode(credentials: RpcCredentials) {
        viewController?.navigationController?.pushViewController(NodeConnectRouter.module(credentials: credentials), animated: true)
    }

}

extension NodeCredentialsRouter {

    static func module() -> UIViewController {
        let router = NodeCredentialsRouter()
        let interactor = NodeCredentialsInteractor()
        let notificationTimer = NotificationTimer()
        let presenter = NodeCredentialsPresenter(interactor: interactor, router: router, notificationTimer: notificationTimer)
        let viewController = NodeCredentialsViewController(delegate: presenter)

        presenter.view = viewController
        notificationTimer.delegate = presenter
        router.viewController = viewController

        return viewController
    }

}
