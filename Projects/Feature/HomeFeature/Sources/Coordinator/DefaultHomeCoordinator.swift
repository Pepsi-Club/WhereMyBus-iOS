import UIKit

import Core
import FeatureDependency

import RxSwift

public final class DefaultHomeCoordinator: HomeCoordinator {
    public var childCoordinators: [Coordinator] = []
    public var navigationController: UINavigationController
    public let coordinatorProvider: CoordinatorProvider
    
    private let favoritesStatus = PublishSubject<FavoritesStatus>()
    private let disposeBag = DisposeBag()
    
    public init(
        navigationController: UINavigationController,
        coordinatorProvider: CoordinatorProvider
    ) {
        self.navigationController = navigationController
        self.coordinatorProvider = coordinatorProvider
    }
    
    public func start() {
        favoritesStatus
            .withUnretained(self)
            .subscribe(
                onNext: { coordinator, status in
                    switch status {
                    case .empty:
                        coordinator.setEmptyVC()
                    case .nonEmpty:
                        coordinator.setFavoritesVC()
                    }
                }
            )
            .disposed(by: disposeBag)
        
        switch UserDefaults.standard.object(forKey: "즐겨찾기있는지") {
        case .none:
            favoritesStatus.onNext(.empty)
        case .some:
            favoritesStatus.onNext(.nonEmpty)
        }
    }
    
    private func setFavoritesVC() {
        let homeViewController = FavoritesViewController(
            viewModel: FavoritesViewModel(coordinator: self)
        )
        navigationController.setViewControllers(
            [homeViewController],
            animated: false
        )
    }
    
    private func setEmptyVC() {
        let emptyFavoritesVC = EmptyFavoritesViewController(
            viewModel: EmptyFavoritesViewModel(coordinator: self)
        )
        navigationController.setViewControllers(
            [emptyFavoritesVC],
            animated: false
        )
    }
    
    public func startSearchFlow() {
        let searchCoordinator = coordinatorProvider.makeSearchCoordinator(
            navigationController: navigationController
        )
        childCoordinators.append(searchCoordinator)
        searchCoordinator.start()
    }
}
extension DefaultHomeCoordinator {
    enum FavoritesStatus {
        case empty, nonEmpty
    }
}
