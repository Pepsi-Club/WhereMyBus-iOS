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
            busStopArrivalInfoResponse: .init(),
            arrivalInfoResponse: .init(), 
            onError: .init()
        )
        
        input.viewWillAppearEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, _ in
                    guard let favorites = try? viewModel.useCase.favorites
                        .value()
                    else { return }
                    let isEmpty = favorites.busStops.isEmpty
                    if isEmpty {
                        viewModel.coordinator.updateFavoritesState(
                            isEmpty: favorites.busStops.isEmpty
                        )
                    } else {
                        viewModel.useCase.fetchFavoritesArrivals()
                    }
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
                viewModel.useCase.fetchFavoritesArrivals()
            }
        )
        .disposed(by: disposeBag)
        
        input.busStopTapEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, sectionIndex in
                    do {
                        let response = try viewModel.useCase
                            .busStopArrivalInfoResponse.value()
                        viewModel.coordinator.startBusStopFlow(
                            stationId: response[sectionIndex].busStopId
                        )
                    } catch {
                        output.onError.onNext(error)
                    }
                }
            )
            .disposed(by: disposeBag)
        
        input.busStopTapEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, index in
                    guard let response = try? viewModel.useCase
                        .busStopArrivalInfoResponse.value()
                    else { return }
                    viewModel.coordinator.startBusStopFlow(
                        stationId: response[index].busStopId
                    )
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
        
        useCase.busStopArrivalInfoResponse
            .bind(
                to: output.busStopArrivalInfoResponse
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
        let alarmBtnTapEvent: Observable<IndexPath>
        let busStopTapEvent: Observable<Int>
    }
    
    public struct Output {
        var busStopArrivalInfoResponse
        : PublishSubject<[BusStopArrivalInfoResponse]>
        var arrivalInfoResponse: PublishSubject<ArrivalInfoResponse>
        var onError: PublishSubject<Error>
    }
}
