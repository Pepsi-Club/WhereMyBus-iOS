import UIKit

import FeatureDependency

public final class DefaultSearchCoordinator: SearchCoordinator {
    public var parent: Coordinator?
    public var childs: [Coordinator] = []
    public var navigationController: UINavigationController
    public let coordinatorProvider: CoordinatorProvider
    
    public init(
        parent: Coordinator?,
        navigationController: UINavigationController,
        coordinatorProvider: CoordinatorProvider
    )
    {
        self.navigationController = navigationController
        self.parent = parent
        self.coordinatorProvider = coordinatorProvider
    }
    
    public func start() {
        let searchViewController = SearchViewController(
            viewModel: SearchViewModel(
                //coordinator: self
            )
        )
        navigationController.pushViewController(
            searchViewController,
            animated: false
        )
    }
    
    public func finish() {
        
    }
}

extension DefaultSearchCoordinator {
    public func startBusStopFlow() {
        	let busStopCoordinator = coordinatorProvider.makeBusStopCoordinator(navigationController: navigationController)
        
        childs.append(busStopCoordinator)
        busStopCoordinator.start()
    }
}
			
