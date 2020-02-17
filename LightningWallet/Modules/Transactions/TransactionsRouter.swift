import UIKit

class TransactionsRouter {
    weak var viewController: UIViewController?
}

extension TransactionsRouter: ITransactionsRouter {

    func dismiss() {
        viewController?.dismiss(animated: true)
    }

}

extension TransactionsRouter {

    static func module() -> UIViewController {
        let router = TransactionsRouter()
        let presenter = TransactionsPresenter(router: router, factory: MainViewFactory())
        let viewController = TransactionsViewController(delegate: presenter)

        router.viewController = viewController
        presenter.view = viewController

        return viewController
    }

}
