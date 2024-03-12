import UIKit

import Domain
import FeatureDependency

public final class DefaultSearchCoordinator
: SearchCoordinator, AfterSearchCoordinator {
    
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
    
    public func goAfterSearchView(text: String) {
        let afterSearchViewController = AfterSearchViewController(
            viewModel: .init(coordinator: self, texts: text)
        )
        navigationController.pushViewController(
            afterSearchViewController,
            animated: true
        )
    }
}

extension DefaultSearchCoordinator {
    public func startHomeFlow() {
        let homeCoordinator = coordinatorProvider.makeSearchCoordinator(
            navigationController: navigationController
        )
//        childs.append(searchCoordinator)
//        serachCoordinator.start()
    }
    
    public func startBusStopFlow(stationId: String) {
        // BusStopCoordinatorFlow
        let busStopCoordinator = coordinatorProvider.makeBusStopCoordinator(
            navigationController: navigationController,
            busStopId: stationId
        )
        childs.append(busStopCoordinator)
        busStopCoordinator.start()
    }
    
    public func complete() {
        navigationController.popViewController(animated: true)
        finish()
    }
}
