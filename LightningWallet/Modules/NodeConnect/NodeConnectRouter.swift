import UIKit
import ThemeKit

class NodeConnectRouter {
    weak var viewController: UIViewController?
}

extension NodeConnectRouter: INodeConnectRouter {
}

extension NodeConnectRouter {

    static func module() -> UIViewController {
        let router = NodeConnectRouter()
        let interactor = NodeConnectInteractor()
        let presenter = NodeConnectPresenter(interactor: interactor, router: router)
        let viewController = NodeConnectViewController(delegate: presenter)

        presenter.view = viewController
        router.viewController = viewController

        return viewController
    }

}
