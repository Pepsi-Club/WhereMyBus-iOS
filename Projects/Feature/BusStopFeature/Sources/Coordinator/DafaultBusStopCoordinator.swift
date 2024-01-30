import UIKit

import FeatureDependency

public final class DefaultBusStopCoordinator: BusStopCoordinator {
    public var parent: Coordinator?
    public var childs: [Coordinator] = []
    public var navigationController: UINavigationController
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let busstopViewController = BusStopViewController(
            viewModel: BusStopViewModel()
        )
        navigationController.setViewControllers(
            [busstopViewController],
            animated: false
        )
    }
    
    public func finish() {
        
    }
}
