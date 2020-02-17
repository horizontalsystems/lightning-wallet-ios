import UIKit
import ThemeKit

class NodeCredentialsRouter {
    weak var viewController: UIViewController?
}

extension NodeCredentialsRouter: INodeCredentialsRouter {

    func openConnectNode(someData: String) {
        viewController?.navigationController?.pushViewController(NodeConnectRouter.module(), animated: true)
    }

}

extension NodeCredentialsRouter {

    static func module() -> UIViewController {
        let router = NodeCredentialsRouter()
        let interactor = NodeCredentialsInteractor()
        let presenter = NodeCredentialsPresenter(interactor: interactor, router: router)
        let viewController = NodeCredentialsViewController(delegate: presenter)

        presenter.view = viewController
        router.viewController = viewController

        return viewController
    }

}
