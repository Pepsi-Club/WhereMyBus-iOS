import Foundation

import Domain
import FeatureDependency

import RxSwift

public final class SettingsViewModel: ViewModel {
    private let disposeBag = DisposeBag()
    
    public init() {
    }
    
    public func transform(input: Input) -> Output {
        let output = Output()
        return output
    }
}

extension SettingsViewModel {
    public struct Input {
    }
    
    public struct Output {
    }
}
