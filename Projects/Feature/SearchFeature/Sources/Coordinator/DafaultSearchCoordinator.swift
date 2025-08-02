import UIKit

import Domain
import FeatureDependency
import NearMapFeatureInterface

public final class DefaultSearchCoordinator: SearchCoordinator {
    public var parent: Coordinator?
    public var childs: [Coordinator] = []
    public let navigationController: UINavigationController
    public weak var busStopCoordinatorDelegate: BusStopCoordinatorDelegate?
    
    private let coordinatorProvider: CoordinatorProvider
    private let nearMapCoordinatorBuilder: NearMapCoordinatorBuilder
    private let flow: FlowState
    
    public init(
        parent: Coordinator?,
        navigationController: UINavigationController,
        coordinatorProvider: CoordinatorProvider,
        nearMapCoordinatorBuilder: NearMapCoordinatorBuilder,
        busStopCoordinatorDelegate: BusStopCoordinatorDelegate?,
        flow: FlowState
    ) {
        self.parent = parent
        self.navigationController = navigationController
        self.coordinatorProvider = coordinatorProvider
        self.nearMapCoordinatorBuilder = nearMapCoordinatorBuilder
        self.busStopCoordinatorDelegate = busStopCoordinatorDelegate
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
    public func startBusStopFlow(busStopID: String) {
        let busStopCoordinator = coordinatorProvider.makeBusStopCoordinator(
            parent: self,
            navigationController: navigationController,
            busStopId: busStopID,
            flow: flow,
            delegate: busStopCoordinatorDelegate
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
    
    public func startNearMapFlow(busStopID: String) {
        let nearMapCoordinator = nearMapCoordinatorBuilder.build(
            parent: self,
            navigationController: navigationController,
            flow: flow, 
            busStopId: busStopID
        )
        childs.append(nearMapCoordinator)
        nearMapCoordinator.start()
    }
}
