import UIKit
import SnapKit

protocol IScanQrCodeDelegate: AnyObject {
    func didScan(string: String)
}

class ScanQrAlertView: UIView {
    private let wrapperView = UIView()
    private let titleLabel = UILabel()

    private let actionButton = UIButton.appSecondary
    private var action: (() -> ())?

    init() {
        super.init(frame: .zero)

        addSubview(wrapperView)
        wrapperView.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview()
            maker.centerY.equalToSuperview()
            maker.top.greaterThanOrEqualToSuperview().offset(CGFloat.margin12x)
        }

        wrapperView.addSubview(titleLabel)
        wrapperView.addSubview(actionButton)

        updateConstraints(showButton: false)

        titleLabel.font = .subhead2
        titleLabel.textColor = .themeGray
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        actionButton.addTarget(self, action: #selector(onTapAction), for: .touchUpInside)

        clipsToBounds = true
        layer.cornerRadius = .cornerRadius2x
        backgroundColor = .black                    // must be black in all themes
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func onTapAction() {
        action?()
    }

    private func updateConstraints(showButton: Bool) {
        titleLabel.snp.remakeConstraints { maker in
            maker.leading.equalToSuperview().offset(CGFloat.margin12x)
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview()
            if !showButton {
                maker.bottom.equalToSuperview()
            }
        }
        actionButton.isHidden = !showButton
        actionButton.snp.remakeConstraints { maker in
            if showButton {
                maker.top.equalTo(titleLabel.snp.bottom).offset(CGFloat.margin6x)
            }
            maker.leading.trailing.equalToSuperview().inset(72)
            maker.height.equalTo(CGFloat.heightButtonSecondary)
            maker.bottom.equalToSuperview()
        }
    }

    func bind(title: String, actionTitle: String? = nil, action: (() -> ())? = nil) {
        self.action = action

        titleLabel.text = title
        actionButton.setTitle(actionTitle, for: .normal)

        updateConstraints(showButton: actionTitle != nil)
    }

}
