import CurrencyKit

protocol IMainSettingsView: class {
    func refresh()

    func set(currentBaseCurrency: String)
    func set(currentLanguage: String?)
    func set(lightMode: Bool)
    func set(appVersion: String)
}

protocol IMainSettingsViewDelegate {
    func viewDidLoad()
    func didTapSecurity()
    func didTapBaseCurrency()
    func didTapLanguage()
    func didSwitch(lightMode: Bool)
    func didTapAbout()
    func didTapTellFriends()
    func didTapContact()
    func didTapCompanyLink()
    func didTapLogOut()
}

protocol IMainSettingsInteractor: AnyObject {
    var companyWebPageLink: String { get }
    var appWebPageLink: String { get }
    var currentLanguageDisplayName: String? { get }
    var baseCurrency: Currency { get }
    var lightMode: Bool { get set }
    var appVersion: String { get }
}

protocol IMainSettingsInteractorDelegate: class {
    func didUpdateBaseCurrency()
}

protocol IMainSettingsRouter {
    func showSecuritySettings()
    func showBaseCurrencySettings()
    func showLanguageSettings()
    func showAbout()
    func showShare(appWebPageLink: String)
    func showContact()
    func open(link: String)
    func reloadAppInterface()
    func showWelcome()
}
