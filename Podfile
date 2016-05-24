platform :ios, '9.0'
use_frameworks!

def shared_pods
end

target 'TournamentBrackets' do
    pod 'RxRealm'
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'RxBlocking'
    pod 'RxDataSources'
    pod 'AKPickerView'
    pod 'RealmSwift'
    pod 'MBProgressHUD'
    pod 'VTAcknowledgementsViewController'
    pod 'UIColor+FlatColors'
    pod 'Charts/Realm'
    shared_pods
end

target 'TournamentBracketsTests' do
    pod 'Quick'
    pod 'Nimble'
end

target 'TournamentBracketsUITests' do
    pod 'Quick'
    pod 'Nimble'
end

post_install do | installer |
    require 'fileutils'
    FileUtils.cp_r('Pods/Target Support Files/Pods-TournamentBrackets/Pods-TournamentBrackets-acknowledgements.plist', 'Pods-acknowledgements.plist', :remove_destination => true)
end