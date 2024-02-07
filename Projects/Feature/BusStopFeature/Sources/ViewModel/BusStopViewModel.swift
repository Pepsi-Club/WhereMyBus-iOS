import Foundation

import Core
import Domain
import FeatureDependency

import RxSwift

public final class BusStopViewModel: ViewModel {
    private let coordinator: BusStopCoordinator
    private let disposeBag = DisposeBag()
    @Injected(BusStopUseCase.self) var useCase: BusStopUseCase
    
    public init(coordinator: BusStopCoordinator) {
        self.coordinator = coordinator
    }
    
    deinit {
        coordinator.finish()
    }
    
    public func transform(input: Input) -> Output {
        let output = Output(
            busStopArrivalInfoResponse: .init()
        )
        
        input.viewWillAppearEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, _ in
                    viewModel.useCase.fetchBusArrivals()
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
        
        return output
    }
}

extension BusStopViewModel {
    public struct Input {
        let viewWillAppearEvent: Observable<Void>
        let likeBusBtnTapEvent: Observable<IndexPath>
        let alarmBtnTapEvent: Observable<IndexPath>
        let likeBusStopBtnTapEvent: Observable<Int>
        let mapBtnTapEvent: Observable<Int>
    }
    
    public struct Output {
        var busStopArrivalInfoResponse
        : PublishSubject<[BusStopArrivalInfoResponse]>
    }
}
