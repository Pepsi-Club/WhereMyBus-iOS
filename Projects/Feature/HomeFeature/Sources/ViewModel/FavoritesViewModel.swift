import Foundation

import Core
import Domain
import FeatureDependency

import RxSwift

public final class FavoritesViewModel: ViewModel {
    private let coordinator: HomeCoordinator
    @Injected(FavoritesUseCase.self) var useCase: FavoritesUseCase
    
    private let disposeBag = DisposeBag()
    
    public init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
    }
    
    deinit {
        coordinator.finish()
    }
    
    public func transform(input: Input) -> Output {
        let output = Output(
            favoritesSections: .init(),
            arrivalInfoResponse: .init()
        )
        
        Observable.combineLatest(
            input.viewWillAppearEvent,
            input.refreshBtnTapEvent
        )
        .withUnretained(self)
        .subscribe(
            onNext: { viewModel, _ in
                viewModel.useCase.fetchFavoritesArrivals()
            }
        )
        .disposed(by: disposeBag)
        
        input.viewWillAppearEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, _ in
                    guard let favorites = try? viewModel.useCase.favorites
                        .value()
                    else { return }
                    viewModel.coordinator.updateFavoritesState(
                        isEmpty: favorites.busStops.isEmpty
                    )
                }
            )
            .disposed(by: disposeBag)
        
        input.searchBtnTapEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, _ in
                    viewModel.coordinator.startSearchFlow()
                }
            )
            .disposed(by: disposeBag)
        
        useCase.favorites
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, favorites in
                    viewModel.coordinator.updateFavoritesState(
                        isEmpty: favorites.busStops.isEmpty
                    )
                }
            )
            .disposed(by: disposeBag)
        
        useCase.favoritesSections
            .bind(
                to: output.favoritesSections
            )
            .disposed(by: disposeBag)
        
        return output
    }
}

extension FavoritesViewModel {
    public struct Input {
        let viewWillAppearEvent: Observable<Void>
        let searchBtnTapEvent: Observable<Void>
        let refreshBtnTapEvent: Observable<Void>
        let likeBtnTapEvent: Observable<IndexPath>
        let alarmBtnTapEvent: Observable<IndexPath>
        let busStopTapEvent: Observable<Int>
    }
    
    public struct Output {
        var favoritesSections: PublishSubject<[FavoritesSection]>
        var arrivalInfoResponse: PublishSubject<ArrivalInfoResponse>
    }
}
