import UIKit

import Domain
import FeatureDependency
import NearMapFeatureInterface
import AlarmFeatureInterface

public final class DefaultBusStopCoordinator: BusStopCoordinator {
    public var parent: Coordinator?
    public var childs: [Coordinator] = []
    public var navigationController: UINavigationController
    public weak var delegate: BusStopCoordinatorDelegate?
    
    private let coordinatorProvider: CoordinatorProvider
    private let busStopId: String
    private let flow: FlowState
    private let nearMapCoordinatorBuilder: NearMapCoordinatorBuilder
    private let addRegularAlarmCoordinatorBuilder: AddRegularAlarmCoordinatorBuilder
    
    public init(
        parent: Coordinator?,
        navigationController: UINavigationController,
        busStopId: String,
        coordinatorProvider: CoordinatorProvider,
        flow: FlowState,
        nearMapCoordinatorBuilder: NearMapCoordinatorBuilder,
        addRegularAlarmCoordinatorBuilder: AddRegularAlarmCoordinatorBuilder,
        delegate: BusStopCoordinatorDelegate?
    ) {
        self.parent = parent
        self.navigationController = navigationController
        self.busStopId = busStopId
        self.coordinatorProvider = coordinatorProvider
        self.flow = flow
        self.nearMapCoordinatorBuilder = nearMapCoordinatorBuilder
        self.addRegularAlarmCoordinatorBuilder = addRegularAlarmCoordinatorBuilder
        self.delegate = delegate
    }
    
    public func start() {
        let fetchData = ArrivalInfoRequest(busStopId: busStopId)
        let busStopViewController = BusStopViewController(
            viewModel: BusStopViewModel(
                coordinator: self,
                fetchData: fetchData,
                flow: flow
            )
        )
        navigationController.pushViewController(
            busStopViewController,
            animated: true
        )
    }
}

extension DefaultBusStopCoordinator {
    // 정류장 위치뷰로 이동하기 위한
    public func busStopMapLocation(busStopId: String) {
        let nearMapCoordinator = nearMapCoordinatorBuilder.build(
            parent: self,
            navigationController: navigationController,
            flow: flow,
            busStopId: busStopId
        )
        childs.append(nearMapCoordinator)
        nearMapCoordinator.start()
    }
    
    public func moveToRegualrAlarm() {
        let alarmCoordinator = addRegularAlarmCoordinatorBuilder.build(
            parent: self,
            navigationController: navigationController,
            flow: .fromAlarm
        )
        childs.append(alarmCoordinator)
        alarmCoordinator.start()
    }
}
