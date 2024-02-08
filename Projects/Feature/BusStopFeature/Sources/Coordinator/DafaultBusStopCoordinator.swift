import UIKit

import Domain
import FeatureDependency

public final class DefaultBusStopCoordinator: BusStopCoordinator {
    public var parent: Coordinator?
    public var childs: [Coordinator] = []
    public var navigationController: UINavigationController
//    public var coordinatorProvider: CoordinatorProvider
    private var arrivalInfoData: ArrivalInfoRequest
    
    public init(
        parent: Coordinator?,
        navigationController: UINavigationController,
        arrivalInfoData: ArrivalInfoRequest
//        coordinatorProvider: CoordinatorProvider
    ) {
        self.parent = parent
        self.navigationController = navigationController
        self.arrivalInfoData = arrivalInfoData
//        self.coordinatorProvider = coordinatorProvider
    }
    
    public func start() {
        let busstopViewController = BusStopViewController(
            viewModel: BusStopViewModel(
                coordinator: self,
                fetchData: arrivalInfoData
            )
        )
        navigationController.setViewControllers(
            [busstopViewController],
            animated: false
        )
    }
    
    public func finish() {
        
    }
}

extension DefaultBusStopCoordinator {
    // 정류장 위치뷰로 이동하기 위한
    public func busStopMapLocation() {
//        let nearMapCoordinator = coordinatorProvider
//            .makeBusStopMapCoordinator(
//                navigationController: navigationController
//            )
//        
//        childs.append(nearMapCoordinator)
//        nearMapCoordinator.start()
    }
}
