import UIKit

import Core
import FeatureDependency

import RxSwift

public final class DefaultHomeCoordinator {
    public var parent: Coordinator?
    public var childs: [Coordinator] = []
    public var navigationController: UINavigationController
    public let coordinatorProvider: CoordinatorProvider
    
    private let favoritesStatus = PublishSubject<FavoritesStatus>()
    private let disposeBag = DisposeBag()
    
    public init(
        parent: Coordinator?,
        navigationController: UINavigationController,
        coordinatorProvider: CoordinatorProvider
    ) {
        self.parent = parent
        self.navigationController = navigationController
        self.coordinatorProvider = coordinatorProvider
    }
    
    public func start() {
        let homeViewController = FavoritesViewController(
            viewModel: FavoritesViewModel(coordinator: self)
        )
        navigationController.setViewControllers(
            [homeViewController],
            animated: false
        )
    }
    
    public func finish() {
        
    }
    
    private func hasViewController(vcType: UIViewController.Type) -> Bool {
        navigationController.viewControllers
            .contains(
                where: { viewController in
                    type(of: viewController) == vcType
                }
            )
    }
}

extension DefaultHomeCoordinator: HomeCoordinator {
    public func updateFavoritesState(isEmpty: Bool) {
        favoritesStatus.onNext(isEmpty ? .empty : .nonEmpty)
    }
    
    public func startSearchFlow() {
        let searchCoordinator = coordinatorProvider.makeSearchCoordinator(
            navigationController: navigationController
        )
        childs.append(searchCoordinator)
        searchCoordinator.start()
    }
    
    public func startBusStopFlow(stationId: String) {
        // BusStopCoordinatorFlow
    }
}

extension DefaultHomeCoordinator {
    enum FavoritesStatus {
        case empty, nonEmpty
    }
}
