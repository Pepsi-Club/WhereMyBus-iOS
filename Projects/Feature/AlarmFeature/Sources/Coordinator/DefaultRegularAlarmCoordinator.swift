import UIKit

import Domain
import FeatureDependency

public final class DefaultRegularAlarmCoordinator: RegularAlarmCoordinator {
    public var parent: Coordinator?
    public var childs: [Coordinator] = []
    public var navigationController: UINavigationController
    public var coordinatorProvider: CoordinatorProvider
    
    public init(
        navigationController: UINavigationController,
        coordinatorProvider: CoordinatorProvider
    ) {
        self.navigationController = navigationController
        self.coordinatorProvider = coordinatorProvider
    }
    
    public func start() {
        let homeViewController = RegularAlarmViewController(
            viewModel: RegularAlarmViewModel(coordinator: self)
        )
        navigationController.setViewControllers(
            [homeViewController],
            animated: false
        )
    }
    
    public func finish() {
        
    }
}

public extension DefaultRegularAlarmCoordinator {
    func startAddRegularAlarmFlow() {
        let addRegularAlarmCoordinator = DefaultAddRegularAlarmCoordinator(
            navigationController: navigationController,
            coordinatorProvider: coordinatorProvider,
            flow: .fromAlarm
        )
        childs.append(addRegularAlarmCoordinator)
        addRegularAlarmCoordinator.start()
    }
    
    func startAddRegularAlarmFlow(with: RegularAlarmResponse) {
        let addRegularAlarmCoordinator = DefaultAddRegularAlarmCoordinator(
            navigationController: navigationController,
            coordinatorProvider: coordinatorProvider,
            flow: .fromAlarm
        )
        childs.append(addRegularAlarmCoordinator)
        addRegularAlarmCoordinator.start(with: with)
    }
}
