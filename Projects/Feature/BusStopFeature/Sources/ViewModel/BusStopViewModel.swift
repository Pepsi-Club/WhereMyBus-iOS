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
            favorites: .init(value: .init([] ) )
        )
        
        input.viewWillAppearEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, _ in
                    viewModel.useCase.fetchBusArrivals(
                        request: viewModel.fetchData
                    )
                }
            ).disposed(by: disposeBag)
        
        input.mapBtnTapEvent
            .withUnretained(self)
            .subscribe { viewModel, _ in
                // TODO: 수정필요
                viewModel.coordinator.busStopMapLocation()
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
        let likeBusBtnTapEvent: Observable<IndexPath>
        let alarmBtnTapEvent: Observable<IndexPath>
        let mapBtnTapEvent: Observable<Int>
    }
    
    public struct Output {
        var busStopArrivalInfoResponse
        : PublishSubject<[BusStopArrivalInfoResponse]>
        var favorites
        : BehaviorSubject<[FavoritesBusStopResponse]>
    }
}
