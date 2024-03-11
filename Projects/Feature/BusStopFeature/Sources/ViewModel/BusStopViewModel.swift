import Foundation

import Core
import Domain
import FeatureDependency

import RxSwift

public final class BusStopViewModel: ViewModel {
    private let coordinator: BusStopCoordinator
    @Injected(BusStopUseCase.self) var useCase: BusStopUseCase
    private let disposeBag = DisposeBag()
    private var fetchData: ArrivalInfoRequest
    
    public init(
        coordinator: BusStopCoordinator,
        fetchData: ArrivalInfoRequest
    ) {
        self.coordinator = coordinator
        self.fetchData = fetchData
    }
    
    deinit {
        coordinator.finish()
    }
    
    public func transform(input: Input) -> Output {
        let output = Output(
            busStopArrivalInfoResponse: .init(),
            favorites: .init(value: .init([])),
            isRefreshing: .init()
        )
        
        input.viewWillAppearEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, _ in
                    output.isRefreshing.onNext(.fetching)
                    viewModel.useCase.fetchBusArrivals(
                        request: viewModel.fetchData
                    )
                }
            )
            .disposed(by: disposeBag)
        
        input.mapBtnTapEvent
            .withLatestFrom(output.busStopArrivalInfoResponse
            ) { _, busStopInfo in
                return busStopInfo
            }
            .withUnretained(self) // weak self 대신이다 ! -> 아님 -> self를 인자로 받아
            .subscribe { viewModel, busStopInfo in
                viewModel.coordinator.busStopMapLocation(
                    busStopId: busStopInfo.busStopId
                )
            }
            .disposed(by: disposeBag)
        
        input.refreshLoading
            .withUnretained(self)
            .subscribe(onNext: { viewModel, _ in
                output.isRefreshing.onNext(.fetching)
                
                viewModel.useCase.fetchBusArrivals(
                    request: viewModel.fetchData
                )
            })
            .disposed(by: disposeBag)
        
        input.likeBusBtnTapEvent
            .withLatestFrom(output.busStopArrivalInfoResponse
            ) { busInfo, busStopInfo in
                return (busInfo, busStopInfo.busStopId)
            }
            .subscribe(onNext: { [weak self] busInfo, busStopId in
                guard let self = self else { return }
                self.useCase.handleFavorites(
                    busStop: busStopId,
                    bus: busInfo
                )
            })
            .disposed(by: disposeBag)
        
        input.navigationBackBtnTapEvent
            .withUnretained(self)
            .subscribe { viewModel, _ in
                viewModel.coordinator.popVC()
            }
            .disposed(by: disposeBag)
        
        useCase.busStopSection
            .withUnretained(self)
            .subscribe(onNext: { _, busStopInfo in
                output.busStopArrivalInfoResponse.onNext(busStopInfo)
                output.isRefreshing.onNext(.fetchComplete)
            })
            .disposed(by: disposeBag)
        
        useCase.favorites
            .bind(to: output.favorites)
            .disposed(by: disposeBag)
        
        return output
    }
}

extension BusStopViewModel {
    enum ViewRefreshState {
        case fetching, fetchComplete
    }
}

extension BusStopViewModel {
    public struct Input {
        let viewWillAppearEvent: Observable<Void>
        let likeBusBtnTapEvent: Observable<BusArrivalInfoResponse>
        let alarmBtnTapEvent: Observable<BusArrivalInfoResponse>
        let mapBtnTapEvent: Observable<Void>
        let refreshLoading: Observable<Void>
        let navigationBackBtnTapEvent: Observable<Void>
    }
    
    public struct Output {
        var busStopArrivalInfoResponse
        : PublishSubject<BusStopArrivalInfoResponse>
        var favorites
        : BehaviorSubject<[FavoritesBusStopResponse]>
        var isRefreshing
        : PublishSubject<ViewRefreshState>
    }
}
