import UIKit

class ChannelsRouter {
    weak var viewController: UIViewController?
}

extension ChannelsRouter: IChannelsRouter {

    func dismiss() {
        viewController?.dismiss(animated: true)
    }

}

extension ChannelsRouter {

    static func module() -> UIViewController {
        let router = ChannelsRouter()
        let presenter = ChannelsPresenter(router: router)
        let viewController = ChannelsViewController(delegate: presenter)

        presenter.view = viewController
        router.viewController = viewController

        return viewController
    }

}
