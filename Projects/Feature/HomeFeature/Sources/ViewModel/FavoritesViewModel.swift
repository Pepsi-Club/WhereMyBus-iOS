import Foundation

import Domain
import FeatureDependency

import RxSwift

public final class FavoritesViewModel: ViewModel {
    private let coordinator: HomeCoordinator
    
    private let disposeBag = DisposeBag()
    
    public init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
    }
    
    public func transform(input: Input) -> Output {
        let output = Output()
        
        input.searchBtnTapEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, _ in
                    viewModel.coordinator.startSearchFlow()
                }
            )
            .disposed(by: disposeBag)
        
        return output
    }
}

extension FavoritesViewModel {
    public struct Input {
        let viewDidLoadEvent: Observable<Void>
        let searchBtnTapEvent: Observable<Void>
        let refreshBtnTapEvent: Observable<Void>
        let likeBtnTapEvent: Observable<IndexPath>
        let alarmBtnTapEvent: Observable<IndexPath>
        let stationTapEvent: Observable<Int>
    }
    
    public struct Output {
    }
}
