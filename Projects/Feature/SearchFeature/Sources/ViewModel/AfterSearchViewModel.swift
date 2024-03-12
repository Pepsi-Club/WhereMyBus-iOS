import Domain
import Core
import FeatureDependency

import RxSwift

public final class AfterSearchViewModel: ViewModel {
    
    private let coordinator: AfterSearchCoordinator
    
    @Injected(SearchUseCase.self) var useCase: SearchUseCase
    
    private let disposeBag = DisposeBag()
    
    public init(coordinator: AfterSearchCoordinator) {
        self.coordinator = coordinator
    }
    
    deinit {
        coordinator.finish()
    }
    
    public func transform(input: Input) -> Output {
        let output = Output()
        
        return output
    }
}

extension AfterSearchViewModel {
    public struct Input {
        let viewWillAppearEvenet: Observable<Void>
        let backBtnTapEvent: Observable<Void>
        let cellTapEvent: Observable<Void> //얘는 아웃풋으로 나와야하나?
    }
    
    public struct Output {
        
    }
}
