import UIKit

import Core
import FeatureDependency

public final class DefaultHomeCoordinator: HomeCoordinator {
    public var childCoordinators: [Coordinator] = []
    public var navigationController: UINavigationController
    public let coordinatorProvider: CoordinatorProvider
    
    public init(
        navigationController: UINavigationController,
        coordinatorProvider: CoordinatorProvider
    ) {
        self.navigationController = navigationController
        self.coordinatorProvider = coordinatorProvider
    }
    
    public func start() {
        let homeViewController = HomeViewController(
            viewModel: HomeViewModel(coordinator: self)
        )
        navigationController.setViewControllers(
            [homeViewController],
            animated: false
        )
    }
    
    public func startSearchFlow() {
        let searchCoordinator = coordinatorProvider.makeSearchCoordinator(
            navigationController: navigationController
        )
        childCoordinators.append(searchCoordinator)
        searchCoordinator.start()
    }
}
