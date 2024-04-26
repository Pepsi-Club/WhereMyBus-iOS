import Foundation

import Core
import Domain
import FeatureDependency

import RxSwift

public final class BusStopViewModel: ViewModel {
    private let coordinator: BusStopCoordinator
    @Injected(BusStopUseCase.self)
    private var useCase: BusStopUseCase
    private let disposeBag = DisposeBag()
    private var fetchData: ArrivalInfoRequest
    private let flow: FlowState
    
    public init(
        coordinator: BusStopCoordinator,
        fetchData: ArrivalInfoRequest,
        flow: FlowState
    ) {
        self.coordinator = coordinator
        self.fetchData = fetchData
        self.flow = flow
    }
    
    deinit {
        coordinator.finish()
    }
    
    public func transform(input: Input) -> Output {
        let output = Output(
            busStopArrivalInfoResponse: .init(),
            isRefreshing: .init()
        )
        
        input.viewWillAppearEvent
            .take(1)
            .withUnretained(self)
            .bind(
                onNext: { viewModel, _ in
                    if viewModel.flow == .fromAlarm {
                        output.isRefreshing.onNext(.fetching)
                        viewModel.useCase.fetchBusArrivals(
                            request: viewModel.fetchData
                        )
                    }
                }
            )
            .disposed(by: disposeBag)
        
        input.viewWillAppearEvent
            .withUnretained(self)
            .bind(
                onNext: { viewModel, _ in
                    if viewModel.flow == .fromHome {
                        output.isRefreshing.onNext(.fetching)
                        viewModel.useCase.fetchBusArrivals(
                            request: viewModel.fetchData
                        )
                    }
                }
            )
            .disposed(by: disposeBag)
        
        input.mapBtnTapEvent
            .withLatestFrom(
                output.busStopArrivalInfoResponse
            ) { _, busStopInfo in
                return busStopInfo
            }
            .withUnretained(self)
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
            .withLatestFrom(
                output.busStopArrivalInfoResponse
            ) { busInfo, busStopInfo in
                return (busInfo, busStopInfo.busStopId, busStopInfo.busStopName)
            }
            .withUnretained(self)
            .subscribe(
                onNext: { vm, tuple in
                    let (busInfo, busStopId, busStopName) = tuple
                    do {
                        try vm.useCase.handleFavorites(
                            isFavorites: busInfo.isFavorites,
                            favorites: .init(
                                busStopId: busStopId,
                                busStopName: busStopName,
                                busId: busInfo.busId,
                                busName: busInfo.busName,
                                adirection: busInfo.adirection
                            )
                        )
                    } catch {
                        #if DEBUG
                        print(error.localizedDescription)
                        #endif
                    }
//                self.useCase.handleFavorites(
//                    busStop: busStopId,
//                    bus: busInfo
//                )
            })
            .disposed(by: disposeBag)
        
        input.navigationBackBtnTapEvent
            .withUnretained(self)
            .subscribe { viewModel, _ in
                viewModel.coordinator.finishFlow()
            }
            .disposed(by: disposeBag)
        
        input.cellSelectTapEvent
            .withLatestFrom(
                output.busStopArrivalInfoResponse
            ) { busInfo, busStopInfo in
                return (busInfo, busStopInfo)
            }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, arg1 in
                let (busInfo, busStopInfo) = arg1
                viewModel.useCase.update(
                    busStopInfo: busStopInfo,
                    busInfo: busInfo
                )
                viewModel.coordinator.finishFlow(upTo: .addAlarm)
            })
            .disposed(by: disposeBag)
        
        useCase.busStopSection
            .withUnretained(self)
            .subscribe(onNext: { _, busStopInfo in
                output.busStopArrivalInfoResponse.onNext(busStopInfo)
                output.isRefreshing.onNext(.fetchComplete)
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    func getBusStopFlow() -> FlowState {
        return flow
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
        let cellSelectTapEvent: Observable<BusArrivalInfoResponse>
    }
    
    public struct Output {
        var busStopArrivalInfoResponse
        : PublishSubject<BusStopArrivalInfoResponse>
        var isRefreshing
        : PublishSubject<ViewRefreshState>
    }
}
