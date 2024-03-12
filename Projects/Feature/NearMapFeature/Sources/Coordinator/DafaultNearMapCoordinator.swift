import UIKit

import FeatureDependency

import RxSwift
import KakaoMapsSDK

public final class DefaultNearMapCoordinator: NearMapCoordinator {
	
	// MARK: - Property
	
	public var navigationController: UINavigationController
    public var parent: Coordinator?
    public var childs: [Coordinator] = []
	public let coordinatorProvider: CoordinatorProvider
    
	private let disposeBag = DisposeBag()
	
	// MARK: - Init
    
    public init(
		parent: Coordinator?,
		navigationController: UINavigationController,
		coordinatorProvider: CoordinatorProvider
	) {
		self.parent = parent
        self.navigationController = navigationController
		self.coordinatorProvider = coordinatorProvider
    }
	
	// MARK: - Function
    
    public func start() {
        let nearmapViewController = NearMapViewController(
			viewModel: NearMapViewModel(coordinator: self)
        )
        navigationController.setViewControllers(
            [nearmapViewController],
            animated: false
        )
    }
    
    public func finish() {
        
    }
}
