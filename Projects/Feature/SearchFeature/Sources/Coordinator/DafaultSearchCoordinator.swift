import UIKit

import FeatureDependency

public final class DefaultSearchCoordinator: SearchCoordinator {
    public var childCoordinators: [Coordinator] = []
    public var navigationController: UINavigationController
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let searchViewController = SearchViewController(
            viewModel: SearchViewModel()
        )
        navigationController.pushViewController(
            searchViewController,
            animated: true
        )
    }
}
