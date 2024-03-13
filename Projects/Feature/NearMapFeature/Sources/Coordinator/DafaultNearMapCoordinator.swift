import UIKit

import FeatureDependency

import RxSwift
import KakaoMapsSDK

public final class DefaultNearMapCoordinator: NearMapCoordinator {
    
    public var parent: Coordinator?
    public var childs: [Coordinator] = []
    public var navigationController: UINavigationController
    private let flow: FlowState
    
    private let disposeBag = DisposeBag()
    
    public init(
        parent: Coordinator?,
        navigationController: UINavigationController,
        flow: FlowState
    ) {
        self.parent = parent
        self.navigationController = navigationController
        self.flow = flow
    }
    
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
