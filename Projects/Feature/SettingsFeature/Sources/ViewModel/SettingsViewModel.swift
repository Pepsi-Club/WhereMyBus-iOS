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
                viewModel.coordinator.setDefaultAlarm()
                print("알람설정 tap")
            })
            .disposed(by: disposeBag)
        
        input.termsTapEvent
            .withUnretained(self)
            .subscribe(onNext: { viewModel, _ in
//                viewModel.coordinator.
                print("이용약관 tap")
            })
            .disposed(by: disposeBag)
        
        return output
    }
}

extension SettingsViewModel {
    public struct Input {
        let defaultAlarmTapEvent: Observable<Void>
        let termsTapEvent: Observable<Void>
    }
    
    public struct Output {
    }
}
