import UIKit

import FeatureDependency

public final class DefaultNearMapCoordinator: NearMapCoordinator {
    public var parent: Coordinator?
    public var childs: [Coordinator] = []
    public var navigationController: UINavigationController
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let nearmapViewController = NearMapViewController(
            viewModel: NearMapViewModel()
        )
        navigationController.setViewControllers(
            [nearmapViewController],
            animated: false
        )
    }
    
    public func finish() {
        
    }
}
