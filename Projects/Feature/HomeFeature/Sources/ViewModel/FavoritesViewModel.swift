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
        
        vmFetchStatus // VMStatus, VCStatus 바인딩
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
        /*
         input의 fetchRequest 이벤트는 vmFetchStatus이 complete나 finalPage인 상태에서만
         바인딩, PublishSubject이기 때문에 초기값이 없어 1번은 VM에서 수동 호출
         */
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
        
        vmFetchStatus.onNext(.firstFetching) // 상단의 수동 호출과 같은 맥락
        
        Observable.merge( // fakeFetching, firstFetching 상태 업데이트
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
        
        vmFetchStatus // fakeFetcing 이벤트 처리
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
        
        vmFetchStatus // firstFetch 이벤트 처리
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
        
        input.scrollReachedBtmEvent // nextFetch 상태 업데이트 및 이벤트 처리
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
        
        input.searchBtnTapEvent // 검색버튼 탭 이벤트 처리
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, _ in
                    viewModel.coordinator.startSearchFlow()
                }
            )
            .disposed(by: disposeBag)
        
        input.busStopTapEvent // 정류장(헤더) 탭 이벤트 처리
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, selectedId in
                    viewModel.coordinator.startBusStopFlow(
                        stationId: selectedId
                    )
                }
            )
            .disposed(by: disposeBag)
        // fetch한 데이터를 타이머로 가공하여 시간 정보가 변경된 경우만 output 바인딩
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
