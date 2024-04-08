import UIKit

public protocol SettingsCoordinator: Coordinator {
    func setDefaultAlarm()
    func presentPrivacy(url: String)
    func presentMail(vc: UIViewController)
}
