import Foundation

import Domain
import Core
import FeatureDependency

import RxSwift

public final class SearchViewModel: ViewModel {
    private let coordinator: SearchCoordinator
    private let disposeBag = DisposeBag()
    
    public init(
        coordinator: SearchCoordinator
    ) {
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

extension SearchViewModel {
    public struct Input {
        let viewWillAppearEvenet: Observable<Void>
        let searchEnterEvent: Observable<String>
        let searchTapEvenet: Observable<IndexPath>
    }
    
    public struct Output {
        //?? 이 데이터를 넘겨줘야하나 
    }
}
