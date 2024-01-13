import UIKit

import FeatureDependency

public final class DefaultMyCoordinator: MyCoordinator {
    public var childCoordinators: [Coordinator] = []
    public var navigationController: UINavigationController
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let myViewController = MyViewController(
            viewModel: MyViewModel()
        )
        navigationController.setViewControllers(
            [myViewController],
            animated: false
        )
    }
}
