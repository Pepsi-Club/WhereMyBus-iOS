import Foundation

import Core
import Domain
import FeatureDependency

import RxSwift
import RxRelay

public final class FavoritesViewModel: ViewModel {
    private let coordinator: HomeCoordinator
    @Injected(FavoritesUseCase.self) var useCase: FavoritesUseCase
    
    private let vmFetchStatus = PublishSubject<VMFetchStatus>()
    private let fetchedResponse = PublishSubject<[BusStopArrivalInfoResponse]>()
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
            fetchStatus: .init()
        )
        
        vmFetchStatus
            .map { status in
                switch status {
                case .firstFetching, .nextFetching, .fakeFetching:
                    return .fetching
                case .fetchComplete, .finalPage:
                    return .fetchComplete
                }
            }
            .bind(to: output.fetchStatus)
            .disposed(by: disposeBag)
        
        vmFetchStatus.onNext(.firstFetching)
        
        useCase.fetchFirstPage()
            .withUnretained(self)
            .subscribe(
                onNext: { vm, responses in
                    vm.vmFetchStatus.onNext(.fetchComplete)
                    vm.fetchedResponse.onNext(responses)
                    vm.timer.start()
                }
            )
            .disposed(by: disposeBag)
        
        Observable.merge(
            input.viewWillAppearEvent,
            input.refreshBtnTapEvent
        )
        .withLatestFrom(vmFetchStatus)
        .filter { status in
            status == .fetchComplete || status == .finalPage
        }
        .withLatestFrom(timer.distanceFromStart)
        .map { timerValue in
            if timerValue < 20 {
                return VMFetchStatus.fakeFetching
            } else {
                return VMFetchStatus.firstFetching
            }
        }
        .withUnretained(self)
        .subscribe(
            onNext: { vm, status in
                if status == .firstFetching {
                    vm.timer.stop()
                }
                vm.vmFetchStatus.onNext(status)
            }
        )
        .disposed(by: disposeBag)
        
        vmFetchStatus // Fake Fetch
            .filter { state in
                state == .fakeFetching
            }
            .withUnretained(self)
            .flatMapLatest { vm, _ in
                vm.useCase.fakeFetch()
            }
            .withUnretained(self)
            .subscribe(
                onNext: { vm, responses in
                    vm.fetchedResponse.onNext(responses)
                    vm.vmFetchStatus.onNext(.fetchComplete)
                }
            )
            .disposed(by: disposeBag)
        
        vmFetchStatus // FirstPage Fetch
            .filter { state in
                state == .firstFetching
            }
            .withUnretained(self)
            .flatMapLatest { vm, _ in
                vm.useCase.fetchFirstPage()
            }
            .withUnretained(self)
            .subscribe(
                onNext: { vm, responses in
                    vm.vmFetchStatus.onNext(.fetchComplete)
                    vm.fetchedResponse.onNext(responses)
                    vm.timer.start()
                }
            )
            .disposed(by: disposeBag)
        
        input.scrollReachedBtmEvent // NextPage Fetch
            .withLatestFrom(vmFetchStatus)
            .filter { status in
                status == .fetchComplete
            }
            .withUnretained(self)
            .flatMapLatest { vm, _ in
                vm.vmFetchStatus.onNext(.nextFetching)
                return vm.useCase.fetchNextPage()
            }
            .withLatestFrom(fetchedResponse) { newPage, oldPage in
                (newPage, oldPage)
            }
            .withUnretained(self)
            .subscribe(
                onNext: { vm, tuple in
                    let (newPage, oldPage) = tuple
                    if newPage.count == oldPage.count {
                        vm.vmFetchStatus.onNext(.finalPage)
                    } else {
                        vm.fetchedResponse.onNext(newPage)
                        vm.vmFetchStatus.onNext(.fetchComplete)
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
            .withLatestFrom(fetchedResponse) { timerValue, responses in
                (timerValue, responses)
            }
            .map { tuple in
                let (timerValue, responses) = tuple
                return responses.map {
                    return $0.replaceTime(timerSecond: timerValue)
                }
            }
            .distinctUntilChanged()
            .bind(to: output.busStopArrivalInfoResponse)
            .disposed(by: disposeBag)
        
        return output        
    }
    
    private func convertFetchRequest(
        refreshEvent: Observable<Void>
    ) {
        refreshEvent
            .withLatestFrom(timer.distanceFromStart)
            .filter { timerValue in
                timerValue >= 20
            }
            .withUnretained(self)
            .subscribe(
                onNext: { vm, _ in
                    vm.vmFetchStatus.onNext(.firstFetching)
                    vm.timer.stop()
                }
            )
            .disposed(by: disposeBag)
        
        refreshEvent
            .withLatestFrom(vmFetchStatus)
            .filter { status in
                status == .fetchComplete ||
                status == .finalPage
            }
            .withLatestFrom(timer.distanceFromStart)
            .filter { timerValue in
                timerValue < 20
            }
            .withUnretained(self)
            .subscribe(
                onNext: { vm, _ in
                    vm.vmFetchStatus.onNext(.fakeFetching)
                }
            )
            .disposed(by: disposeBag)
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
        let busStopArrivalInfoResponse
        : PublishSubject<[BusStopArrivalInfoResponse]>
        let fetchStatus: PublishSubject<VCFetchStatus>
    }
    
    enum VMFetchStatus {
        case firstFetching, nextFetching
        case fakeFetching
        case fetchComplete, finalPage
    }
    
    enum VCFetchStatus {
        case fetching, fetchComplete
    }
}
