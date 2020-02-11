import UIKit
import SnapKit

class WelcomeScreenViewController: UIViewController {
    private let delegate: IWelcomeScreenViewDelegate

    private let topWrapper = UIView()
    private let titleWrapper = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    private let createButton = UIButton.appYellow
    private let restoreButton = UIButton.appGray
    private let connectButton = UIButton.appGreen
    private let versionLabel = UILabel()

    init(delegate: IWelcomeScreenViewDelegate) {
        self.delegate = delegate

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(topWrapper)
        topWrapper.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide)
            maker.leading.trailing.equalToSuperview()
        }

        topWrapper.addSubview(titleWrapper)
        titleWrapper.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.leading.trailing.equalToSuperview().inset(CGFloat.margin8x)
        }

        titleLabel.text = "welcome.title".localized
        titleLabel.numberOfLines = 0
        titleLabel.font = .title2
        titleLabel.textColor = .themeOz

        titleWrapper.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { maker in
            maker.leading.top.trailing.equalToSuperview()
        }

        subtitleLabel.text = "welcome.subtitle".localized
        subtitleLabel.font = .body
        subtitleLabel.textColor = .themeGray

        titleWrapper.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { maker in
            maker.leading.trailing.bottom.equalToSuperview()
            maker.top.equalTo(titleLabel.snp.bottom).offset(CGFloat.margin4x)
        }

        createButton.setTitle("welcome.new_wallet".localized, for: .normal)
        createButton.addTarget(self, action: #selector(onTapCreate), for: .touchUpInside)

        view.addSubview(createButton)
        createButton.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(CGFloat.margin6x)
            maker.top.equalTo(topWrapper.snp.bottom)
            maker.height.equalTo(CGFloat.heightButton)
        }

        restoreButton.setTitle("welcome.restore_wallet".localized, for: .normal)
        restoreButton.addTarget(self, action: #selector(onTapRestore), for: .touchUpInside)

        view.addSubview(restoreButton)
        restoreButton.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(CGFloat.margin6x)
            maker.top.equalTo(createButton.snp.bottom).offset(CGFloat.margin4x)
            maker.height.equalTo(CGFloat.heightButton)
        }

        connectButton.setTitle("welcome.connect_to_remote_node".localized, for: .normal)
        connectButton.addTarget(self, action: #selector(onTapConnect), for: .touchUpInside)

        view.addSubview(connectButton)
        connectButton.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(CGFloat.margin6x)
            maker.top.equalTo(restoreButton.snp.bottom).offset(CGFloat.margin4x)
            maker.height.equalTo(CGFloat.heightButton)
        }

        versionLabel.textColor = .themeGray
        versionLabel.font = .caption

        view.addSubview(versionLabel)
        versionLabel.snp.makeConstraints { maker in
            maker.top.equalTo(connectButton.snp.bottom).offset(CGFloat.margin4x)
            maker.bottom.equalTo(view.safeAreaLayoutGuide).inset(CGFloat.margin4x)
            maker.centerX.equalToSuperview()
        }

        delegate.viewDidLoad()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @objc func onTapCreate() {
        delegate.onTapCreate()
    }

    @objc func onTapRestore() {
        delegate.onTapRestore()
    }

    @objc func onTapConnect() {
        delegate.onTapConnect()
    }

}

extension WelcomeScreenViewController: IWelcomeScreenView {

    func set(appVersion: String) {
        versionLabel.text = "welcome.version".localized(appVersion)
    }

}
