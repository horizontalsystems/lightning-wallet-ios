import UIKit
import ThemeKit
import SnapKit
import HUD

class NodeCredentialsViewController: ThemeViewController {
    private let delegate: INodeCredentialsViewDelegate

    private let scanView = ScanQrView()

    private let descriptionLabel = UILabel()
    private let errorLabel = UILabel()
    private let pasteButton = UIButton.appGray

    init(delegate: INodeCredentialsViewDelegate) {
        self.delegate = delegate

        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        TransparentNavigationBar.set(to: navigationController?.navigationBar)

        view.addSubview(scanView)
        scanView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        scanView.delegate = self

        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(CGFloat.margin6x)
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(CGFloat.margin3x)
        }
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .themeLeah
        descriptionLabel.font = .subhead2
        descriptionLabel.text = "node_credentials.description".localized

        view.addSubview(errorLabel)
        errorLabel.snp.makeConstraints { maker in
            maker.edges.equalTo(descriptionLabel)
        }
        errorLabel.numberOfLines = 0
        errorLabel.textAlignment = .center
        errorLabel.textColor = .themeLucian
        errorLabel.font = .subhead2

        view.addSubview(pasteButton)
        pasteButton.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(CGFloat.margin6x)
            maker.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(CGFloat.margin8x)
            maker.height.equalTo(CGFloat.heightButton)
        }

        pasteButton.setTitle("Paste", for: .normal)
        pasteButton.addTarget(self, action: #selector(onPaste), for: .touchUpInside)

        delegate.onLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        scanView.start()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        scanView.stop()
    }

    @objc func onPaste() {
        delegate.onPaste()
    }

}

extension NodeCredentialsViewController: IScanQrCodeDelegate {

    func didScan(string: String) {
        delegate.onScan(string: string)
    }

}

extension NodeCredentialsViewController: INodeCredentialsView {

    func showDescription() {
        descriptionLabel.isHidden = false
        errorLabel.isHidden = true
    }

    func showEmptyPasteboard() {
        descriptionLabel.isHidden = true

        errorLabel.text = "node_credentials.empty_clipboard".localized
        errorLabel.isHidden = false
    }

    func showError() {
        descriptionLabel.isHidden = true

        errorLabel.text = "node_credentials.invalid_code".localized
        errorLabel.isHidden = false
    }

    func notifyScan() {
        HapticGenerator.instance.notification(.success)
    }

    func stopScan() {
        scanView.stop()
    }

}
