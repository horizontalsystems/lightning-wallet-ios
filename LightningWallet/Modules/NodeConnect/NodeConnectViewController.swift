import UIKit
import ThemeKit
import SnapKit

class NodeConnectViewController: ThemeViewController {
    private let delegate: INodeConnectViewDelegate

    private let addressLabel = UILabel()
    private let connectButton = UIButton.appGreen

    init(delegate: INodeConnectViewDelegate) {
        self.delegate = delegate

        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .always
        title = "node_connect.title".localized
        TransparentNavigationBar.set(to: navigationController?.navigationBar)

        view.addSubview(addressLabel)
        addressLabel.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(CGFloat.margin6x)
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(CGFloat.margin4x)
        }
        addressLabel.textColor = .themeLeah
        addressLabel.font = .title3

        view.addSubview(connectButton)
        connectButton.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(CGFloat.margin6x)
            maker.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(CGFloat.margin8x)
            maker.height.equalTo(CGFloat.heightButton)
        }

        connectButton.setTitle("Connect", for: .normal)
        connectButton.addTarget(self, action: #selector(onConnect), for: .touchUpInside)

        delegate.onLoad()
    }

    @objc func onConnect() {
        delegate.onTapConnect()
    }

}

extension NodeConnectViewController: INodeConnectView {

    func show(address: String) {
        addressLabel.text = address
    }

    func showConnecting() {
        HudHelper.instance.showSpinner(title: "node_connect.connecting".localized, userInteractionEnabled: false)
    }

    func hideConnecting() {
        HudHelper.instance.hide()
    }

    func showError(error: Error) {
        HudHelper.instance.showError(subtitle: error.localizedDescription)
    }

}
