import UIKit

import FeatureDependency

public final class DefaultAlarmCoordinator: AlarmCoordinator {
    public var childCoordinators: [Coordinator] = []
    public var navigationController: UINavigationController
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let homeViewController = AlarmViewController(
            viewModel: AlarmViewModel()
        )
        navigationController.setViewControllers(
            [homeViewController],
            animated: false
        )
    }
}
