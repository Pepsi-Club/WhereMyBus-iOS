import Foundation

public protocol SettingsCoordinator: Coordinator {
    func setDefaultAlarm()
    func presentTermsPrivacy()
    func presentLocationPrivacy()
}
