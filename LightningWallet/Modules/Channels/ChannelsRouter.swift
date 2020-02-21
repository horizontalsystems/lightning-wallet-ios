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
        guard let lightningKit = App.shared.lightningKitManager.currentKit else {
            // TODO: show empty view controller with message
            fatalError()
        }

        let router = ChannelsRouter()
        let interactor = ChannelsInteractor(lightningKit: lightningKit)
        let presenter = ChannelsPresenter(interactor: interactor, router: router)
        let viewController = ChannelsViewController(delegate: presenter)

        router.viewController = viewController
        interactor.delegate = presenter
        presenter.view = viewController

        return viewController
    }

}
