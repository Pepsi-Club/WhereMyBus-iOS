import Foundation

import Domain
import PresentationDependency

import RxSwift

public final class HomeViewModel: ViewModel {
    private let disposeBag = DisposeBag()
    
    public init() {
    }
    
    public func transform(input: Input) -> Output {
        let output = Output()
        return output
    }
}

extension HomeViewModel {
    public struct Input {
    }
    
    public struct Output {
    }
}
