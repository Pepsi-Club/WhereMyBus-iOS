import Foundation

import Domain
import FeatureDependency

import RxSwift

public final class SettingsViewModel: ViewModel {
    private let coordinator: SettingsCoordinator
    private let disposeBag = DisposeBag()
    
    public init(coordinator: SettingsCoordinator) {
        self.coordinator = coordinator
    }
    
    public func transform(input: Input) -> Output {
        let output = Output()
        
        input.defaultAlarmTapEvent
            .withUnretained(self)
            .subscribe(onNext: { viewModel, _ in
                // 뷰 이동
//                viewModel.coordinator.
                print("taptap")
            })
            .disposed(by: disposeBag)
        
        return output
    }
}

extension SettingsViewModel {
    public struct Input {
        let defaultAlarmTapEvent: Observable<Void>
    }
    
    public struct Output {
    }
}
