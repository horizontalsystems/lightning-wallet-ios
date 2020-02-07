import UIKit
import ThemeKit

class MainViewController: ThemeTabBarController {

    init(viewControllers: [UIViewController], selectedIndex: Int) {
        super.init()

        self.viewControllers = viewControllers
        self.selectedIndex = selectedIndex
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
