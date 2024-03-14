import UIKit

import Domain
import FeatureDependency

public final class DefaultSearchCoordinator
: SearchCoordinator, AfterSearchCoordinator {
    
    public var parent: Coordinator?
    public var childs: [Coordinator] = []
    public var navigationController: UINavigationController
    public let coordinatorProvider: CoordinatorProvider
    private let flow: FlowState
    
    public init(
        parent: Coordinator?,
        navigationController: UINavigationController,
        coordinatorProvider: CoordinatorProvider,
        flow: FlowState
    ) {
        self.navigationController = navigationController
        self.parent = parent
        self.coordinatorProvider = coordinatorProvider
        self.flow = flow
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
            busStopId: "",
            flow: flow
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
//    public func startHomeFlow() {
//        let homeCoordinator = coordinatorProvider.makeSearchCoordinator(
//            navigationController: navigationController
//        )
//        childs.append(searchCoordinator)
//        serachCoordinator.start()
//    }
//
    public func startBusStopFlow(stationId: String) {
        // BusStopCoordinatorFlow
        let busStopCoordinator = coordinatorProvider.makeBusStopCoordinator(
            navigationController: navigationController,
            busStopId: stationId,
            flow: flow
        )
        childs.append(busStopCoordinator)
        busStopCoordinator.start()
    }
    
    // MARK: 여기는 협의 후에 
    public func startNearMapFlow(stationId: String) {
        let nearMapCoordinator = coordinatorProvider.makeNearMapCoordinator(
            navigationController: navigationController,
            busStopId: stationId,
            flow: flow
        )
    }
    
    public func popVC() {
        navigationController.popViewController(animated: true)
        finish()
    }
}
