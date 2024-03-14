import Foundation

import Domain
import Core
import FeatureDependency

import RxSwift

public final class AfterSearchViewModel: ViewModel {
    
    public let coordinator: SearchCoordinator
    
    @Injected(SearchUseCase.self) var useCase: SearchUseCase
    
    private let disposeBag = DisposeBag()

    private let texts: String
    
    public init(
        coordinator: SearchCoordinator,
        texts: String
    ) {
        self.coordinator = coordinator
        self.texts = texts
    }
    
    deinit {
        coordinator.finish()
    }
    
    public func transform(input: Input) -> Output {
        let output = Output(
            jsontoSearchResponse: Observable.just([])
        )
        
        input.viewWillAppearEvenet
            .withUnretained(self)
            .subscribe(onNext: { _, _ in
                
            })
            .disposed(by: disposeBag)
        
        input.backBtnTapEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, _ in
                    viewModel.coordinator.popVC()
                })
            .disposed(by: disposeBag)

        input.cellTapEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, stationId in
                    viewModel.coordinator.startBusStopFlow(stationId: stationId)
                    // cell을 [BusInfoResponse]로 보내야함
                })
            .disposed(by: disposeBag)

        return output
    }
}

extension AfterSearchViewModel {
    public struct Input {
        let viewWillAppearEvenet: Observable<Void>
        let backBtnTapEvent: Observable<Void>
        let cellTapEvent: Observable<String>
    }
    
    public struct Output {
        let jsontoSearchResponse: Observable<[BusStopInfoResponse]>
    }
}
