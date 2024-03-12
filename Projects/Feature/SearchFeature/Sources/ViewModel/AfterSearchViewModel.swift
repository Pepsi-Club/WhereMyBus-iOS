import Foundation

import Domain
import Core
import FeatureDependency

import RxSwift

public final class AfterSearchViewModel: ViewModel {
    
    private let coordinator: AfterSearchCoordinator
    
    @Injected(SearchUseCase.self) var useCase: SearchUseCase
    
    private let disposeBag = DisposeBag()
    
    private let texts: String
    
    public init(
        coordinator: AfterSearchCoordinator,
        texts: String
    ) {
        self.coordinator = coordinator
        self.texts = texts
    }
    
    deinit {
        coordinator.finish()
    }
    
    public func transform(input: Input) -> Output {
        let output = Output()
        
        input.viewWillAppearEvenet
            .withUnretained(self)
            .subscribe(onNext: { viewModel, _ in
                viewModel.useCase.searchBusStop(with: self.texts)
            })
        
        input.backBtnTapEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewmodel, _ in
                })
        return output
    }
}

extension AfterSearchViewModel {
    public struct Input {
        let viewWillAppearEvenet: Observable<Void>
        let backBtnTapEvent: Observable<Void>
        let cellTapEvent: Observable<Void>
        let textEditingEvent: Observable<String>
    }
    
    public struct Output {
        // 텍스트 온넥스트 시키고 인풋이 바뀌면 filtering해오라고~
    }
}
