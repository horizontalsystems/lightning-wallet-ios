import UIKit
import SnapKit

class ChannelCell: UITableViewCell {
    private let label = UILabel()

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(label)
        label.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(viewItem: ChannelViewItem) {
        label.text = "Remote PubKey: \(viewItem.remotePubKey)\nLocalBalance: \(viewItem.localBalance)\nRemote Balance: \(viewItem.remoteBalance)"
    }

}
