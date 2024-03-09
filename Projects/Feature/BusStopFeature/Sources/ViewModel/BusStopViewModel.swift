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
                    viewModel.useCase.fetchBusArrivals(
                        request: viewModel.fetchData
                    )
                }
            )
            .disposed(by: disposeBag)
        
        input.mapBtnTapEvent
            .withUnretained(self)
            .subscribe(onNext: { viewModel, busStopArrival in
                // 여기서 강묵님쪽으로 데이터 넘겨주면 될듯
                viewModel.coordinator.busStopMapLocation(
                    busStopId: busStopArrival.busStopId
                )
            })
            .disposed(by: disposeBag)
        
        input.refreshLoading
            .withUnretained(self)
            .subscribe(onNext: { viewModel, bool in
                if bool {
                    viewModel.useCase.fetchBusArrivals(
                        request: viewModel.fetchData
                    )
                    output.isRefreshing.onNext(false)
                }
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
                print("눌리나요")
                viewModel.coordinator.popVC()
            }
            .disposed(by: disposeBag)
        
        useCase.busStopSection
            .bind(
                to: output.busStopArrivalInfoResponse
            )
            .disposed(by: disposeBag)
        
        useCase.favorites
            .bind(to: output.favorites)
            .disposed(by: disposeBag)
        
        return output
    }
}

extension BusStopViewModel {
    public struct Input {
        let viewWillAppearEvent: Observable<Void>
        let likeBusBtnTapEvent: Observable<BusArrivalInfoResponse>
        let alarmBtnTapEvent: Observable<BusArrivalInfoResponse>
        let mapBtnTapEvent: Observable<BusStopArrivalInfoResponse>
        let refreshLoading: Observable<Bool>
        let navigationBackBtnTapEvent: Observable<Void>
    }
    
    public struct Output {
        var busStopArrivalInfoResponse
        : PublishSubject<BusStopArrivalInfoResponse>
        var favorites
        : BehaviorSubject<[FavoritesBusStopResponse]>
        var isRefreshing
        : PublishSubject<Bool>
    }
}
