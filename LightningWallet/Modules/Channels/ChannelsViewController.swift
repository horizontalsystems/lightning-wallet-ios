import UIKit
import ThemeKit
import UIExtensions
import SnapKit

class ChannelsViewController: ThemeViewController {
    private let delegate: IChannelsViewDelegate

    private let tableView = UITableView(frame: .zero, style: .plain)

    private let newChannelButton: UIButton = .appGray
    private let newChannelButtonWrapper = GradientView(gradientHeight: .margin4x, fromColor: .clear, toColor: UIColor.themeDark.withAlphaComponent(0.9))

    init(delegate: IChannelsViewDelegate) {
        self.delegate = delegate

        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        title = "channels".localized

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "backup".localized, style: .plain, target: self, action: #selector(onTapBackup))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "close".localized, style: .plain, target: self, action: #selector(onTapClose))

        view.addSubview(tableView)
        view.addSubview(newChannelButtonWrapper)
        newChannelButtonWrapper.addSubview(newChannelButton)

        tableView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        newChannelButtonWrapper.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
        newChannelButton.snp.makeConstraints { maker in
            maker.top.equalTo(newChannelButtonWrapper.snp.top).offset(CGFloat.margin4x)
            maker.leading.trailing.equalToSuperview().inset(CGFloat.margin6x)
            maker.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(CGFloat.margin8x)
            maker.height.equalTo(CGFloat.heightButton)
        }

        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.estimatedRowHeight = 0
        tableView.delaysContentTouches = false

        newChannelButton.setTitle("channels.new_channel".localized, for: .normal)
        newChannelButton.addTarget(self, action: #selector(onNewChannel), for: .touchUpInside)

        delegate.onLoad()
    }

    @objc private func onTapBackup() {
        print("onTapBackup")
    }

    @objc private func onTapClose() {
        delegate.onClose()
    }

    @objc private func onNewChannel() {
        delegate.onNewChannel()
    }

}

extension ChannelsViewController: IChannelsView {

}

extension ChannelsViewController: UITableViewDataSource, UITableViewDelegate {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }

}
