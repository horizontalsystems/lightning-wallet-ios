import UIKit
import ThemeKit
import UIExtensions

class TransactionsViewController: ThemeViewController {
    let delegate: ITransactionsViewDelegate

    private let depositButton: UIButton = .appGreen
    private let sendButton: UIButton = .appYellow

    private let mainButton = UIButton()
    private let mainButtonWrapper = GradientView(gradientHeight: .heightButton / 2, fromColor: UIColor.themeCassandra.withAlphaComponent(0), toColor: UIColor.themeCassandra.withAlphaComponent(0.9))

    private let tableView = UITableView(frame: .zero, style: .plain)

    private var items: [TransactionViewItem]?

    init(delegate: ITransactionsViewDelegate) {
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

        view.addSubview(depositButton)
        view.addSubview(sendButton)
        view.addSubview(tableView)
        view.addSubview(mainButtonWrapper)
        mainButtonWrapper.addSubview(mainButton)

        depositButton.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(CGFloat.margin4x)
            maker.leading.equalToSuperview().offset(CGFloat.margin6x)
            maker.height.equalTo(CGFloat.heightButton)
        }
        sendButton.snp.makeConstraints { maker in
            maker.top.equalTo(depositButton)
            maker.leading.equalTo(depositButton.snp.trailing).offset(CGFloat.margin2x)
            maker.trailing.equalToSuperview().inset(CGFloat.margin6x)
            maker.height.equalTo(CGFloat.heightButton)
            maker.width.equalTo(depositButton)
        }

        tableView.snp.makeConstraints { maker in
            maker.top.equalTo(depositButton.snp.bottom).offset(CGFloat.margin6x)
            maker.leading.trailing.bottom.equalToSuperview()
        }

        mainButtonWrapper.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
        mainButton.snp.makeConstraints { maker in
            maker.top.equalTo(mainButtonWrapper.snp.top)
            maker.leading.trailing.equalToSuperview()
            maker.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            maker.height.equalTo(CGFloat.heightButton)
        }

        depositButton.setTitle("receive".localized, for: .normal)
        depositButton.addTarget(self, action: #selector(onTapDeposit), for: .touchUpInside)

        sendButton.setTitle("send".localized, for: .normal)
        sendButton.addTarget(self, action: #selector(onTapSend), for: .touchUpInside)

        mainButton.setImage(UIImage(named: "Arrow Down"), for: .normal)
        mainButton.addTarget(self, action: #selector(onTapMain), for: .touchUpInside)

        tableView.registerCell(forClass: TransactionCell.self)
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.estimatedRowHeight = 0
        tableView.delaysContentTouches = false

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

    @objc private func onTapMain() {
        delegate.onMain()
    }

}

extension TransactionsViewController: ITransactionsView {

    func set(balance: String?) {
        title = balance
    }

}

extension TransactionsViewController: UITableViewDataSource, UITableViewDelegate {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items?.count ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeueReusableCell(withIdentifier: String(describing: TransactionCell.self), for: indexPath)
    }

}
