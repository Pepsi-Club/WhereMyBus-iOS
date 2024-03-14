import UIKit

import FeatureDependency

import RxSwift
import KakaoMapsSDK

public final class DefaultNearMapCoordinator: NearMapCoordinator {
    public var parent: Coordinator?
    public var childs: [Coordinator] = []
    public var navigationController: UINavigationController
    public var coordinatorProvider: CoordinatorProvider
	
    public init(
        parent: Coordinator?,
        navigationController: UINavigationController,
        coordinatorProvider: CoordinatorProvider
	) {
		self.parent = parent
        self.navigationController = navigationController
		self.coordinatorProvider = coordinatorProvider
    }
	
	// MARK: - Function
    
    public func start() {
        let nearmapViewController = NearMapViewController(
			viewModel: NearMapViewModel(coordinator: self)
        )
        navigationController.pushViewController(
            nearmapViewController,
            animated: true
        )
    }
}

extension DefaultNearMapCoordinator {
    public func startBusStopFlow(busStopId: String) {
        let busStopCoordinator = coordinatorProvider.makeBusStopCoordinator(
            navigationController: navigationController,
            busStopId: busStopId
        )
        childs.append(busStopCoordinator)
        busStopCoordinator.start()
    }
	
}
