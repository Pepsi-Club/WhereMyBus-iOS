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
            arrivalInfoList: .init(), 
            arrivalInfoResponse: .init()
        )
        
        input.viewWillAppearEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, _ in
                    viewModel.useCase.requestBusStopArrivalInfo()
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
        
        input.refreshBtnTapEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, _ in
                    viewModel.useCase.requestBusStopArrivalInfo()
                }
            )
            .disposed(by: disposeBag)
        
        useCase.arrivalInfoList
            .bind(
                to: output.arrivalInfoList
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
        var arrivalInfoList: PublishSubject<[RouteArrivalInfo]>
        var arrivalInfoResponse: PublishSubject<ArrivalInfoResponse>
    }
}
