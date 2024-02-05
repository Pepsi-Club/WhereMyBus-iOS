import Foundation

import Domain
import FeatureDependency

import RxSwift

public final class NearMapViewModel: ViewModel {
	
	private let coordinator: NearMapCoordinator
    private let disposeBag = DisposeBag()
    
	public init(coordinator: NearMapCoordinator) {
		self.coordinator = coordinator
    }
    
    public func transform(input: Input) -> Output {
        let output = Output()
        return output
    }
}

extension NearMapViewModel {
    public struct Input {
    }
    
    public struct Output {
    }
}
