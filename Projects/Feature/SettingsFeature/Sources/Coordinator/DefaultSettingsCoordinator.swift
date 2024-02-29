import UIKit

import FeatureDependency

public final class DefaultSettingsCoordinator {
    public var parent: Coordinator?
    public var childs: [Coordinator] = []
    public var navigationController: UINavigationController

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    public func start() {
//        let homeViewController = AlarmSettingViewController(
//            viewModel: SettingsViewModel(coordinator: self)
        let settingsViewController = SettingsViewController(
            viewModel: SettingsViewModel(coordinator: self)
        )
        navigationController.setViewControllers(
            [settingsViewController],
            animated: false
        )
    }

    public func finish() {

    }
}

extension DefaultSettingsCoordinator: SettingsCoordinator {
    public func setDefaultAlarm() {
        // 다음 view로 이동 (예시)
//        let setAlarmVC = AlarmSettingViewController(
//            viewModel: SettingsViewModel(coordinator: self)
//        )
//        navigationController.pushViewController(setAlarmVC, animated: true)
    }
    
    public func presentPrivacy(url: String) {
        let privacyVC = PrivacyWebViewController(
            viewModel: PrivacyWebViewModel(
                coordinator: self,
                urlString: url
            )
        )
        navigationController.pushViewController(privacyVC, animated: true)
    }
}
