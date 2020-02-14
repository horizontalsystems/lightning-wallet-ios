import UIKit
import UIExtensions

class ScanQRBlurView: CustomIntensityVisualEffectView {
    private let sideMargin: CGFloat
    private let maskLayer = CAShapeLayer()

    init(sideMargin: CGFloat) {
        self.sideMargin = sideMargin

        super.init(effect: UIBlurEffect(style: .themeHud), intensity: 0.7)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func layoutBlurMask() {
        let path = UIBezierPath (
                roundedRect: bounds,
                cornerRadius: 0)

        let width = self.width - 2 * sideMargin
        let vMargin = (self.height - width) / 2

        let transparentRect = UIBezierPath (
                roundedRect: bounds.inset(by: UIEdgeInsets(top: vMargin, left: sideMargin, bottom: vMargin, right: sideMargin)),
                cornerRadius: .cornerRadius2x)

        path.append(transparentRect)
        path.usesEvenOddFillRule = true

        maskLayer.path = path.cgPath
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd

        layer.mask = maskLayer                 //for iOS > 11.*
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layoutBlurMask()
    }

}
