import Foundation

import Core
import Domain
import FeatureDependency

import RxSwift
import RxRelay

public final class FavoritesViewModel: ViewModel {
    private let coordinator: HomeCoordinator
    @Injected(FavoritesUseCase.self) var useCase: FavoritesUseCase
    
    private let disposeBag = DisposeBag()
    private var timer: BCTimer
    
    public init(
        coordinator: HomeCoordinator,
        timer: BCTimer
    ) {
        self.coordinator = coordinator
        self.timer = timer
    }
    
    deinit {
        coordinator.finish()
    }
    
    public func transform(input: Input) -> Output {
        let output = Output(
            busStopArrivalInfoResponse: .init(value: []),
            favoritesState: .init(),
            distanceFromTimerStart: .init(value: 0)
        )
        
        let fetchRequest = Observable.merge(
            input.viewWillAppearEvent,
            input.refreshBtnTapEvent
        )
        
        fetchRequest
            .subscribe(
                onNext: { _ in
                    output.favoritesState.onNext(.fakeFetching)
                }
            )
            .disposed(by: disposeBag)
        
        fetchRequest
            .throttle(
                .seconds(20),
                latest: false,
                scheduler: MainScheduler.asyncInstance
            )
            .subscribe(
                onNext: { _ in
                    output.favoritesState.onNext(.realFetching)
                }
            )
            .disposed(by: disposeBag)
        
        output.favoritesState
            .filter { state in
                state == .realFetching
            }
            .withUnretained(self)
            .flatMap { vm, _ in
                vm.useCase.fetchFavoritesArrivals()
            }
            .subscribe(
                onNext: { responses in
                    output.favoritesState.onNext(.fetchComplete)
                    output.busStopArrivalInfoResponse.accept(responses)
                }
            )
            .disposed(by: disposeBag)
        
        output.favoritesState
            .filter { state in
                state == .fakeFetching
            }
            .delay(
                .seconds(3),
                scheduler: MainScheduler.asyncInstance
            )
            .subscribe(
                onNext: { state in
                    if state == .fakeFetching {
                        output.favoritesState.onNext(.fetchComplete)
                        output.busStopArrivalInfoResponse.accept(
                            output.busStopArrivalInfoResponse.value
                        )
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
        
        input.busStopTapEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, selectedId in
                    viewModel.coordinator.startBusStopFlow(
                        stationId: selectedId
                    )
                }
            )
            .disposed(by: disposeBag)
        
        timer.distanceFromStart
            .bind(to: output.distanceFromTimerStart)
            .disposed(by: disposeBag)
        
        output.favoritesState
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, state in
                    switch state {
                    case .realFetching, .fakeFetching:
                        viewModel.timer.stop()
                    case .fetchComplete:
                        viewModel.timer.start()
                    }
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
        let alarmBtnTapEvent: Observable<IndexPath>
        let busStopTapEvent: Observable<String>
    }
    
    public struct Output {
        var busStopArrivalInfoResponse
        : BehaviorRelay<[BusStopArrivalInfoResponse]>
        var favoritesState: PublishSubject<FavoritesState>
        var distanceFromTimerStart: BehaviorRelay<Int>
    }
    
    enum FavoritesState {
        case realFetching, fakeFetching, fetchComplete
    }
}
