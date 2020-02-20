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

        balanceTitleBackground.addSubview(balanceTitleLabel)
        balanceTitleLabel.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(CGFloat.margin3x)
            maker.top.bottom.equalToSuperview().inset(CGFloat.margin1x)
        }

        balanceHolderView.addSubview(balanceTitleBackground)
        balanceHolderView.addSubview(coinLabel)
        balanceHolderView.addSubview(currencyLabel)

        balanceWrapperView.addSubview(balanceHolderView)
        view.addSubview(balanceWrapperView)

        view.addSubview(depositButton)
        view.addSubview(sendButton)
        view.addSubview(transactionsButton)

        balanceWrapperView.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            maker.bottom.equalTo(depositButton.snp.top)
            maker.leading.trailing.equalToSuperview()
        }
        balanceHolderView.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.leading.trailing.equalToSuperview()
        }
        balanceTitleBackground.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.centerX.equalToSuperview()
        }
        coinLabel.snp.makeConstraints { maker in
            maker.top.equalTo(balanceTitleBackground.snp.bottom).offset(CGFloat.margin3x)
            maker.centerX.equalToSuperview()
        }
        currencyLabel.snp.makeConstraints { maker in
            maker.top.equalTo(coinLabel.snp.bottom).offset(CGFloat.margin2x)
            maker.centerX.equalToSuperview()
            maker.bottom.equalToSuperview()
        }

        depositButton.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().offset(CGFloat.margin6x)
            maker.height.equalTo(CGFloat.heightButton)
        }
        sendButton.snp.makeConstraints { maker in
            maker.leading.equalTo(depositButton.snp.trailing).offset(CGFloat.margin2x)
            maker.trailing.equalToSuperview().inset(CGFloat.margin6x)
            maker.bottom.equalTo(depositButton)
            maker.height.equalTo(CGFloat.heightButton)
            maker.width.equalTo(depositButton)
        }
        transactionsButton.snp.makeConstraints { maker in
            maker.top.equalTo(depositButton.snp.bottom).offset(CGFloat.margin4x)
            maker.leading.trailing.equalToSuperview()
            maker.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            maker.height.equalTo(CGFloat.heightButton)
        }

        balanceTitleBackground.backgroundColor = .themeJeremy
        balanceTitleBackground.cornerRadius = .margin3x

        balanceTitleLabel.font = .subhead1
        balanceTitleLabel.text = "main_controller.total_balance".localized
        coinLabel.font = .title1
        currencyLabel.font = .headline2

        depositButton.setTitle("receive".localized, for: .normal)
        depositButton.addTarget(self, action: #selector(onTapDeposit), for: .touchUpInside)

        sendButton.setTitle("send".localized, for: .normal)
        sendButton.addTarget(self, action: #selector(onTapSend), for: .touchUpInside)

        transactionsButton.setImage(UIImage(named: "Arrow Up"), for: .normal)
        transactionsButton.addTarget(self, action: #selector(onTapTransactions), for: .touchUpInside)

        delegate.onLoad()
    }

    @objc private func onTapChannels() {
        delegate.onChannels()
    }

    @objc private func onTapSettings() {
        delegate.onSettings()
    }

    @objc private func onTapDeposit() {
        delegate.onDeposit()
    }

    @objc private func onTapSend() {
        delegate.onSend()
    }

    @objc private func onTapTransactions() {
        delegate.onTransactions()
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

    func showErrorStatus(error: Error) {
        syncLabel.text = error.localizedDescription
        syncLabel.isHidden = false
    }

    func hideStatus() {
        syncLabel.isHidden = true
    }

    func show(totalBalance: Int) {
        coinLabel.text = "\(totalBalance) sat"
    }

}
