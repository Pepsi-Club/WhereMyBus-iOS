import UIKit

import FeatureDependency

public final class DefaultMapCoordinator: MapCoordinator {
    public var childCoordinators: [Coordinator] = []
    public var navigationController: UINavigationController
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let mapViewController = MapViewController(
            viewModel: MapViewModel()
        )
        navigationController.setViewControllers(
            [mapViewController],
            animated: false
        )
    }
}
