import Foundation

import Core
import Domain
import FeatureDependency

import RxSwift 
import KakaoMapsSDK

public final class NearMapViewModel: ViewModel {
	
	private let coordinator: NearMapCoordinator
	@Injected(NearMapUseCase.self) var useCase: NearMapUseCase
	
	private let disposeBag = DisposeBag()
	
	public init(coordinator: NearMapCoordinator) {
		self.coordinator = coordinator
	}
	
	deinit {
		coordinator.finish()
	}
	
	public func transform(input: Input) -> Output {
		let output = Output(
		)
		return output
	}
	
}

extension NearMapViewModel {
	public struct Input {
		let clickBusStop: Observable<Void>
	}
	
	public struct Output {
	}
}
