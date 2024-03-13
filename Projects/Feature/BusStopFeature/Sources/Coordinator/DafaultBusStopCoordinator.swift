import UIKit

import Domain
import FeatureDependency

public final class DefaultBusStopCoordinator: BusStopCoordinator {
    public var parent: Coordinator?
    public var childs: [Coordinator] = []
    public var navigationController: UINavigationController
    public var coordinatorProvider: CoordinatorProvider
    private var busStopId: String
    private let flow: FlowState
    
    public init(
        parent: Coordinator?,
        navigationController: UINavigationController,
        busStopId: String,
        coordinatorProvider: CoordinatorProvider,
        flow: FlowState
    ) {
        self.parent = parent
        self.navigationController = navigationController
        self.busStopId = busStopId
        self.coordinatorProvider = coordinatorProvider
        self.flow = flow
    }
    
    public func start() {
        let fetchData = ArrivalInfoRequest(busStopId: busStopId)
        switch flow {
        case .fromHome:
            let busstopViewController = BusStopViewController(
                viewModel: BusStopViewModel(
                    coordinator: self,
                    fetchData: fetchData
                ),
                flow: .fromHome
            )
            
            navigationController.setViewControllers(
                [busstopViewController],
                animated: false
            )
        case .fromAlarm:
            let busstopViewController = BusStopViewController(
                viewModel: BusStopViewModel(
                    coordinator: self,
                    fetchData: fetchData
                ),
                flow: .fromAlarm
            )
            navigationController.setViewControllers(
                [busstopViewController],
                animated: false
            )
        }
    }
}

extension DefaultBusStopCoordinator {
    // 정류장 위치뷰로 이동하기 위한
    public func busStopMapLocation(busStopId: String) {
        let nearMapCoordinator = coordinatorProvider
            .makeBusStopMapCoordinator(
                navigationController: navigationController,
                busStopId: busStopId,
                flow: flow
            )
        
        childs.append(nearMapCoordinator)
        nearMapCoordinator.start()
    }
    
    public func popVC() {
        navigationController.popViewController(animated: true)
        finish()
    }
}
