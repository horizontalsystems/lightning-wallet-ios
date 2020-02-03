platform :ios, '11'
use_modular_headers!

inhibit_all_warnings!

project 'LightningWallet'

def appPods
  pod 'UIExtensions.swift', git: 'https://github.com/horizontalsystems/gui-kit/'
  # pod 'UIExtensions.swift', path: '../gui-kit/'
  pod 'ThemeKit.swift', git: 'https://github.com/horizontalsystems/component-kit-ios/'
  # pod 'ThemeKit.swift', path: '../component-kit-ios/'
  pod 'LanguageKit.swift', git: 'https://github.com/horizontalsystems/component-kit-ios/'
  # pod 'LanguageKit.swift', path: '../component-kit-ios/'

  pod 'Alamofire'
  pod 'ObjectMapper'

  pod 'GRDB.swift'
  pod 'KeychainAccess'

  pod 'RxSwift'
  pod 'SnapKit'
end

target 'LightningWallet' do
  appPods
end
