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
        title = "Address"
        TransparentNavigationBar.set(to: navigationController?.navigationBar)

        view.addSubview(addressLabel)
        addressLabel.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(CGFloat.margin6x)
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(CGFloat.margin4x)
        }
        addressLabel.textColor = .themeGray
        addressLabel.font = .subhead1
        addressLabel.text = "Address"

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
//        delegate.onPaste()
    }

}

extension NodeConnectViewController: INodeConnectView {
}
