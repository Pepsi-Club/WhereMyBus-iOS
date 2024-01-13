import UIKit

import FeatureDependency

public final class DefaultHomeCoordinator: HomeCoordinator {
    public var childCoordinators: [Coordinator] = []
    public var navigationController: UINavigationController
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let homeViewController = HomeViewController(
            viewModel: HomeViewModel()
        )
        navigationController.setViewControllers(
            [homeViewController],
            animated: false
        )
    }
}
