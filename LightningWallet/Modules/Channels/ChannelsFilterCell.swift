import UIKit
import SnapKit

class ChannelsFilterCell: UICollectionViewCell {
    private let roundedView = UIView()
    private let nameLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(roundedView)
        roundedView.addSubview(nameLabel)

        roundedView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview().inset(UIEdgeInsets(top: 6, left: 0, bottom: 10, right: 0))
        }

        roundedView.layer.cornerRadius = 14
        roundedView.layer.borderWidth = .heightOnePixel
        roundedView.clipsToBounds = true

        nameLabel.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
        }

        nameLabel.font = .subhead2
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    override var isSelected: Bool {
        get {
            super.isSelected
        }
        set {
            super.isSelected = newValue
            bind(selected: newValue)
        }
    }

    func bind(title: String, selected: Bool) {
        nameLabel.text = title

        bind(selected: selected)
    }

    func bind(selected: Bool) {
        nameLabel.textColor = selected ? .themeDark : .themeOz
        roundedView.backgroundColor = selected ? .themeYellowD : .themeJeremy
        roundedView.layer.borderColor = selected ? UIColor.clear.cgColor : UIColor.themeSteel20.cgColor
    }

}
