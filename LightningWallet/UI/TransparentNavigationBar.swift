import UIKit

class TransparentNavigationBar {

    static func set(to navigationBar: UINavigationBar?) {
//         set navigation theme for iOS less than 13
        if #available(iOS 13.0, *) {
            let transparentAppearance = UINavigationBarAppearance()
            transparentAppearance.configureWithTransparentBackground()
            transparentAppearance.titleTextAttributes = [.foregroundColor: UIColor.themeOz]
            transparentAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.themeOz]

            navigationBar?.standardAppearance = transparentAppearance
            navigationBar?.scrollEdgeAppearance = transparentAppearance
        } else {
            let colorImage = UIImage(color: .clear)
            navigationBar?.setBackgroundImage(colorImage, for: .default)
            navigationBar?.shadowImage = UIImage()
            return
        }

    }

}
