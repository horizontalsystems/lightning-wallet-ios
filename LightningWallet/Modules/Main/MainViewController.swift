import UIKit
import ThemeKit
import SnapKit

class MainViewController: ThemeViewController {
    private let delegate: IMainViewDelegate

    private let syncLabel = UILabel()

    private let balanceWrapperView = UIView()
    private let balanceHolderView = UIView()
    private let balanceTitleBackground = UIView()
    private let balanceTitleLabel = UILabel()
    private let coinLabel = UILabel()
    private let currencyLabel = UILabel()

    private let unlockButton: UIButton = .appGreen

    private let depositButton: UIButton = .appGreen
    private let sendButton: UIButton = .appYellow

    private let transactionsButton = UIButton()

    init(delegate: IMainViewDelegate) {
        self.delegate = delegate

        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = false

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "channels".localized, style: .plain, target: self, action: #selector(onTapChannels))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Settings Icon"), style: .plain, target: self, action: #selector(onTapSettings))

        view.addSubview(syncLabel)
        syncLabel.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(CGFloat.margin4x)
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(CGFloat.margin3x)
        }

        syncLabel.numberOfLines = 0
        syncLabel.textAlignment = .center
        syncLabel.font = .subhead2
        syncLabel.textColor = .themeLeah

        view.addSubview(balanceWrapperView)
        balanceWrapperView.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            maker.leading.trailing.equalToSuperview()
        }

        balanceWrapperView.addSubview(balanceHolderView)
        balanceHolderView.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.leading.trailing.equalToSuperview()
        }

        balanceHolderView.addSubview(balanceTitleBackground)
        balanceTitleBackground.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.centerX.equalToSuperview()
        }

        balanceTitleBackground.backgroundColor = .themeJeremy
        balanceTitleBackground.cornerRadius = .margin3x

        balanceTitleBackground.addSubview(balanceTitleLabel)
        balanceTitleLabel.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(CGFloat.margin3x)
            maker.top.bottom.equalToSuperview().inset(CGFloat.margin1x)
        }

        balanceTitleLabel.font = .subhead1
        balanceTitleLabel.text = "main_controller.total_balance".localized

        balanceHolderView.addSubview(coinLabel)
        coinLabel.snp.makeConstraints { maker in
            maker.top.equalTo(balanceTitleBackground.snp.bottom).offset(CGFloat.margin3x)
            maker.centerX.equalToSuperview()
        }

        coinLabel.font = .title1

        balanceHolderView.addSubview(currencyLabel)
        currencyLabel.snp.makeConstraints { maker in
            maker.top.equalTo(coinLabel.snp.bottom).offset(CGFloat.margin2x)
            maker.centerX.equalToSuperview()
            maker.bottom.equalToSuperview()
        }

        currencyLabel.font = .headline2

        balanceWrapperView.addSubview(unlockButton)
        unlockButton.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
            maker.height.equalTo(CGFloat.heightButton)
        }

        unlockButton.setTitle("Unlock Wallet", for: .normal)
        unlockButton.addTarget(self, action: #selector(onTapUnlock), for: .touchUpInside)

        view.addSubview(depositButton)
        depositButton.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().offset(CGFloat.margin6x)
            maker.top.equalTo(balanceWrapperView.snp.bottom)
            maker.height.equalTo(CGFloat.heightButton)
        }

        depositButton.setTitle("receive".localized, for: .normal)
        depositButton.addTarget(self, action: #selector(onTapDeposit), for: .touchUpInside)

        view.addSubview(sendButton)
        sendButton.snp.makeConstraints { maker in
            maker.leading.equalTo(depositButton.snp.trailing).offset(CGFloat.margin2x)
            maker.trailing.equalToSuperview().inset(CGFloat.margin6x)
            maker.bottom.equalTo(depositButton)
            maker.height.equalTo(CGFloat.heightButton)
            maker.width.equalTo(depositButton)
        }

        sendButton.setTitle("send".localized, for: .normal)
        sendButton.addTarget(self, action: #selector(onTapSend), for: .touchUpInside)

        view.addSubview(transactionsButton)
        transactionsButton.snp.makeConstraints { maker in
            maker.top.equalTo(depositButton.snp.bottom).offset(CGFloat.margin4x)
            maker.leading.trailing.equalToSuperview()
            maker.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            maker.height.equalTo(CGFloat.heightButton)
        }

        transactionsButton.setImage(UIImage(named: "Arrow Up"), for: .normal)
        transactionsButton.addTarget(self, action: #selector(onTapTransactions), for: .touchUpInside)

        delegate.onLoad()
    }

    @objc private func onTapUnlock() {
        delegate.onTapUnlock()
    }

    @objc private func onTapChannels() {
        delegate.onTapChannels()
    }

    @objc private func onTapSettings() {
        delegate.onTapSettings()
    }

    @objc private func onTapDeposit() {
        delegate.onTapDeposit()
    }

    @objc private func onTapSend() {
        delegate.onTapSend()
    }

    @objc private func onTapTransactions() {
        delegate.onTapTransactions()
    }

}

extension MainViewController: IMainView {

    func showConnectingStatus() {
        syncLabel.text = "Connecting..."
        syncLabel.isHidden = false
    }

    func showSyncingStatus() {
        syncLabel.text = "Synchronizing..."
        syncLabel.isHidden = false
    }

    func showUnlockingStatus() {
        syncLabel.text = "Unlocking..."
        syncLabel.isHidden = false
    }

    func showLockedStatus() {
        syncLabel.text = "Locked"
        syncLabel.isHidden = false
    }

    func showErrorStatus(error: Error) {
        syncLabel.text = "Connection Error:\n\(error.localizedDescription)"
        syncLabel.isHidden = false
    }

    func hideStatus() {
        syncLabel.isHidden = true
    }

    func setUnlockButton(visible: Bool) {
        unlockButton.isHidden = !visible
    }

    func show(totalBalance: Int) {
        coinLabel.text = "\(totalBalance) sat"
        balanceHolderView.isHidden = false
    }

    func hideTotalBalance() {
        balanceHolderView.isHidden = true
    }

    func setLightningButtons(enabled: Bool) {
        navigationItem.leftBarButtonItem?.isEnabled = enabled
        sendButton.isEnabled = enabled
        depositButton.isEnabled = enabled
        transactionsButton.isEnabled = enabled
    }

}
