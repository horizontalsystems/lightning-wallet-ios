import UIKit
import ThemeKit
import UIExtensions
import SnapKit

class ChannelsViewController: ThemeViewController {
    private let delegate: IChannelsViewDelegate

//    private var channelsHeaderView: ChannelsHeaderView?
    private let tableView = UITableView()

    private let newChannelButton: UIButton = .appGray
    private let newChannelButtonWrapper = GradientView(gradientHeight: .margin4x, fromColor: UIColor.themeCassandra.withAlphaComponent(0), toColor: UIColor.themeCassandra.withAlphaComponent(0.9))

    private var viewItems: [ChannelViewItem] = []

    init(delegate: IChannelsViewDelegate) {
        self.delegate = delegate

        super.init()

//        channelsHeaderView = ChannelsHeaderView(filters: [
//            ("open".localized.uppercased(), onSelectOpen),
//            ("closed".localized.uppercased(), onSelectClosed)
//        ])
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

        tableView.registerCell(forClass: ChannelCell.self)

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

//    func onSelectOpen() {
//        delegate.onSelectOpen()
//    }
//
//    func onSelectClosed() {
//        delegate.onSelectClosed()
//    }

}

extension ChannelsViewController: IChannelsView {

    func show(viewItems: [ChannelViewItem]) {
        self.viewItems = viewItems
        tableView.reloadData()
    }

}

extension ChannelsViewController: UITableViewDataSource, UITableViewDelegate {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewItems.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeueReusableCell(withIdentifier: String(describing: ChannelCell.self), for: indexPath)
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? ChannelCell {
            cell.bind(viewItem: viewItems[indexPath.row])
        }
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }

    //    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        channelsHeaderView
//    }
//
//    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        ChannelsHeaderView.headerHeight
//    }

}
