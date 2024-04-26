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
            busStopArrivalInfoResponse: .init(),
            fetchStatus: .init(),
            distanceFromTimerStart: .init()
        )
        
        let fetchRequest = Observable.merge(
            input.viewWillAppearEvent,
            input.refreshBtnTapEvent
        )
        
        fetchRequest
            .withLatestFrom(output.fetchStatus)
            .filter { status in
                status == .fetchComplete || status == .finalPage
            }
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
                    output.fetchStatus.onNext(.firstFetching)
                    vm.timer.stop()
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
            .withLatestFrom(output.fetchStatus)
            .withLatestFrom(
                output.busStopArrivalInfoResponse
            ) { state, responses in
                (state, responses)
            }
            .withUnretained(self)
            .subscribe(
                onNext: { vm, tuple in
                    let (state, responses) = tuple
                    if state == .fakeFetching {
                        vm.useCase.fakeFetchComplete()
                        output.fetchStatus.onNext(.fetchComplete)
                        output.busStopArrivalInfoResponse.onNext(
                            Array(responses.prefix(5))
                        )
                    }
                }
            )
            .disposed(by: disposeBag)
        
        output.fetchStatus
            .filter { state in
                state == .firstFetching
            }
            .withUnretained(self)
            .flatMap { vm, _ in
                vm.useCase.fetchFirstPage()
            }
            .withUnretained(self)
            .subscribe(
                onNext: { vm, responses in
                    output.fetchStatus.onNext(.fetchComplete)
                    output.busStopArrivalInfoResponse.onNext(responses)
                    vm.timer.start()
                }
            )
            .disposed(by: disposeBag)
        
        input.scrollReachedBtmEvent
            .withLatestFrom(output.fetchStatus)
            .filter { status in
                status == .fetchComplete
            }
            .withUnretained(self)
            .flatMapLatest { vm, _ in
                output.fetchStatus.onNext(.nextFetching)
                return vm.useCase.fetchNextPage()
            }
            .withLatestFrom(
                output.busStopArrivalInfoResponse
            ) { oldPage, newPage in
                (oldPage, newPage)
            }
            .subscribe(
                onNext: { tuple in
                    let (oldPage, newPage) = tuple
                    if oldPage.isEmpty {
                        output.fetchStatus.onNext(.finalPage)
                    } else {
                        let newResponses = (newPage + oldPage)
                        output.busStopArrivalInfoResponse.onNext(newResponses)
                        output.fetchStatus.onNext(.fetchComplete)
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
        let scrollReachedBtmEvent: Observable<Void>
    }
    
    public struct Output {
        var busStopArrivalInfoResponse
        : PublishSubject<[BusStopArrivalInfoResponse]>
        var fetchStatus: PublishSubject<FetchStatus>
        var distanceFromTimerStart: PublishSubject<Int>
    }
    
    enum FetchStatus {
        case firstFetching, nextFetching
        case fakeFetching
        case fetchComplete, finalPage
    }
}
