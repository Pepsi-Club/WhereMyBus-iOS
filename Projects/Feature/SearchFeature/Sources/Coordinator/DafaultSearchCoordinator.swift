import UIKit

import Domain
import FeatureDependency
import NearMapFeatureInterface

public final class DefaultSearchCoordinator: SearchCoordinator {
    public var parent: Coordinator?
    public var childs: [Coordinator] = []
    public let navigationController: UINavigationController
    public var coordinatorType: CoordinatorType = .search
    
    private let coordinatorProvider: CoordinatorProvider
    private let nearMapCoordinatorBuilder: NearMapCoordinatorBuilder
    private let flow: FlowState
    
    public init(
        parent: Coordinator?,
        navigationController: UINavigationController,
        coordinatorProvider: CoordinatorProvider,
        nearMapCoordinatorBuilder: NearMapCoordinatorBuilder,
        flow: FlowState
    ) {
        self.parent = parent
        self.navigationController = navigationController
        self.coordinatorProvider = coordinatorProvider
        self.nearMapCoordinatorBuilder = nearMapCoordinatorBuilder
        self.flow = flow
    }
    
    public func start() {
        let searchViewController = SearchViewController(
            viewModel: SearchViewModel(coordinator: self)
        )
        navigationController.pushViewController(
            searchViewController,
            animated: true
        )
    }
}

extension DefaultSearchCoordinator {
    public func startBusStopFlow(stationId: String) {
        let busStopCoordinator = coordinatorProvider.makeBusStopCoordinator(
            parent: self,
            navigationController: navigationController,
            busStopId: stationId,
            flow: flow
        )
        childs.append(busStopCoordinator)
        busStopCoordinator.start()
    }
    
    public func startNearMapFlow() {
        let nearMapCoordinator = nearMapCoordinatorBuilder.build(
            parent: self,
            navigationController: navigationController,
            flow: flow, 
            busStopId: nil
        )
        childs.append(nearMapCoordinator)
        nearMapCoordinator.start()
    }
    
    public func startNearMapFlow(busStopId: String) {
        let nearMapCoordinator = nearMapCoordinatorBuilder.build(
            parent: self,
            navigationController: navigationController,
            flow: flow, 
            busStopId: busStopId
        )
        childs.append(nearMapCoordinator)
        nearMapCoordinator.start()
    }
}
