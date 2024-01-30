import UIKit

import Core
import FeatureDependency

import RxSwift

public final class DefaultHomeCoordinator: HomeCoordinator {
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
        setFavoritesVC()
    }
    
    private func setFavoritesVC() {
        guard !hasViewController(vcType: FavoritesViewController.self)
        else { return }
        let homeViewController = FavoritesViewController(
            viewModel: FavoritesViewModel(coordinator: self)
        )
        navigationController.setViewControllers(
            [homeViewController],
            animated: false
        )
    }
    
    private func setEmptyVC() {
        guard !hasViewController(vcType: EmptyFavoritesViewController.self)
        else { return }
        let emptyFavoritesVC = EmptyFavoritesViewController(
            viewModel: EmptyFavoritesViewModel(coordinator: self)
        )
        navigationController.setViewControllers(
            [emptyFavoritesVC],
            animated: false
        )
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

extension DefaultHomeCoordinator {
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
    
    public func finish() {
        
    }
}

extension DefaultHomeCoordinator {
    enum FavoritesStatus {
        case empty, nonEmpty
    }
}
