import UIKit

import Domain
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
    ) {
        self.navigationController = navigationController
        self.parent = parent
        self.coordinatorProvider = coordinatorProvider
    }
    
    public func start() {
        let searchViewController = SearchViewController(
            viewModel: SearchViewModel(coordinator: self)
        )
        navigationController.pushViewController(
            searchViewController,
            animated: false
        )
    }
    
    public func finish() {
        
    }
    
    public func startBusStopFlow() {
        let busStopCoordinator =
        coordinatorProvider.makeBusStopCoordinator(
            navigationController: navigationController,
            busStopId: ""
        )
        
        childs.append(busStopCoordinator)
        busStopCoordinator.start()
    }
}

extension DefaultSearchCoordinator: AfterSearchCoordinator {
    public func starts() {
        let afterSearchViewController = AfterSearchViewController(
            viewModel: .init(coordinator: self)
        )
        navigationController.pushViewController(
            afterSearchViewController,
            animated: true
        )
    }
    
    public func startSearchFlow() {
        let searchCoordinator = coordinatorProvider.makeSearchCoordinator(
            navigationController: navigationController
        )
        childs.append(searchCoordinator)
        searchCoordinator.start()
    }
    
    public func complete() {
        navigationController.popViewController(animated: true)
        finish()
    }
}
