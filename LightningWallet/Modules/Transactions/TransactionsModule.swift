
protocol ITransactionsRouter {
    func dismiss()
}

protocol ITransactionsView: class {
    func set(balance: String?)
}

protocol ITransactionsViewDelegate {
    func onLoad()
    func onDeposit()
    func onSend()
    func onMain()
    func onChannels()
    func onSettings()
}
