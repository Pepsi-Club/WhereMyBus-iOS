import Foundation

import Core
import Domain
import FeatureDependency

import RxSwift

public final class FavoritesViewModel: ViewModel {
    private let coordinator: HomeCoordinator
    
    private let disposeBag = DisposeBag()
    
    @Injected(FavoritesUseCase.self) var useCase: FavoritesUseCase
    
    public init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
    }
    
    public func transform(input: Input) -> Output {
        let output = Output(
            arrivalInfoList: .init()
        )
        
        input.viewWillAppearEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, _ in
                    viewModel.useCase.requestStationArrivalInfo(
                        favorites: .init(
                            requests: [.init(stationId: "121000214")]
                        )
                    )
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
        
        useCase.arrivalInfoList
            .bind(
                to: output.arrivalInfoList
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
        let likeBtnTapEvent: Observable<IndexPath>
        let alarmBtnTapEvent: Observable<IndexPath>
        let stationTapEvent: Observable<Int>
    }
    
    public struct Output {
        var arrivalInfoList: PublishSubject<[StationArrivalInfoResponse]>
    }
}
