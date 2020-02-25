import UIKit
import ThemeKit
import SnapKit

class UnlockRemoteWalletViewController: ThemeViewController {
    private let delegate: IUnlockRemoteWalletViewDelegate

    private let descriptionLabel = UILabel()
    private let passwordTextField = UITextField()
    private let unlockButton: UIButton = .appGreen

    init(delegate: IUnlockRemoteWalletViewDelegate) {
        self.delegate = delegate

        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Unlock Wallet"

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(onTapCancel))

        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(CGFloat.margin4x)
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(CGFloat.margin3x)
        }

        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .subhead2
        descriptionLabel.textColor = .themeLeah

        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(CGFloat.margin4x)
            maker.top.equalTo(descriptionLabel.snp.bottom).offset(CGFloat.margin3x)
        }

        passwordTextField.borderWidth = 1
        passwordTextField.borderColor = .themeGray

        view.addSubview(unlockButton)
        unlockButton.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(CGFloat.margin4x)
            maker.top.equalTo(passwordTextField.snp.bottom).offset(CGFloat.margin3x)
            maker.height.equalTo(CGFloat.heightButton)
        }

        unlockButton.setTitle("Unlock", for: .normal)
        unlockButton.addTarget(self, action: #selector(onTapUnlock), for: .touchUpInside)

        delegate.onLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        passwordTextField.becomeFirstResponder()
    }

    @objc private func onTapUnlock() {
        delegate.onTapUnlock(password: passwordTextField.text)
    }

    @objc private func onTapCancel() {
        delegate.onTapCancel()
    }

}

extension UnlockRemoteWalletViewController: IUnlockRemoteWalletView {

    func showUnlocking() {
        passwordTextField.resignFirstResponder()
        HudHelper.instance.showSpinner(title: "Unlocking...", userInteractionEnabled: false)
    }

    func hideUnlocking() {
        HudHelper.instance.hide()
    }

    func show(error: Error) {
        HudHelper.instance.showError(subtitle: error.localizedDescription)
    }

}
