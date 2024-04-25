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
            fetchStatus: .init(),
            distanceFromTimerStart: .init(value: 0)
        )
        
        let fetchRequest = Observable.merge(
            input.viewWillAppearEvent,
            input.refreshBtnTapEvent
        )
        
        fetchRequest
            .subscribe(
                onNext: { _ in
                    output.fetchStatus.onNext(.fakeFetching)
                }
            )
            .disposed(by: disposeBag)
        
        fetchRequest
            .throttle(
                .seconds(20),
                latest: false,
                scheduler: MainScheduler.asyncInstance
            )
            .withUnretained(self)
            .subscribe(
                onNext: { vm, _ in
                    output.fetchStatus.onNext(.realFetching)
                    vm.timer.stop()
                }
            )
            .disposed(by: disposeBag)
        
        output.fetchStatus
            .filter { state in
                state == .realFetching
            }
            .withUnretained(self)
            .flatMap { vm, _ in
                vm.useCase.fetchAllFavorites()
            }
            .withUnretained(self)
            .subscribe(
                onNext: { vm, responses in
                    vm.timer.start()
                    output.fetchStatus.onNext(.fetchComplete)
                    output.busStopArrivalInfoResponse.accept(responses)
                }
            )
            .disposed(by: disposeBag)
        
        output.fetchStatus
            .filter { state in
                state == .fakeFetching
            }
            .delay(
                .seconds(3),
                scheduler: MainScheduler.asyncInstance
            )
            .withLatestFrom(
                output.busStopArrivalInfoResponse
            ) { state, responses in
                (state, responses)
            }
            .subscribe(
                onNext: { state, responses in
                    if state == .fakeFetching {
                        output.fetchStatus.onNext(.fetchComplete)
                        output.busStopArrivalInfoResponse.accept(responses)
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
        var fetchStatus: PublishSubject<FetchStatus>
        var distanceFromTimerStart: BehaviorRelay<Int>
    }
    
    enum FetchStatus {
        case realFetching, fakeFetching, fetchComplete
    }
}
