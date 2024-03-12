import UIKit

import Domain
import Core
import FeatureDependency

import RxSwift

public final class SearchViewModel: ViewModel {
    private let coordinator: SearchCoordinator
    
    @Injected(SearchUseCase.self) var useCase: SearchUseCase
    
    private let disposeBag = DisposeBag()
    public let enterPressedSubject = PublishSubject<Void>()
    
    public init(coordinator: SearchCoordinator) {
        self.coordinator = coordinator
    }
    
    deinit {
        coordinator.finish()
    }
    
    private func handleEnterPressed() {
        
    }
    
    public func transform(input: Input) -> Output {
        let output = Output(
            recentSearchList: .init(value: ""),
            afterSearchEnter: .init())
        
        input.viewWillAppearEvenet
            .withUnretained(self)
            .subscribe(
                // MARK: 필요없을수도
                onNext: { viewModel, _ in
                    viewModel.useCase.getStationList()
                })
            .disposed(by: disposeBag)
        
        input.enterPressedEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, textfield in
                        viewModel.coordinator.goAfterSearchView(
                            text: textfield
                    )
                }
            )
            .disposed(by: disposeBag)
        
        return output
    }
}

extension SearchViewModel {
    public struct Input {
        let viewWillAppearEvenet: Observable<Void>
//        let infoAgreeEvent: Observable<Bool>
        let enterPressedEvent: Observable<String>
        let backbtnEvent: Observable<Void>
    }
    
    public struct Output {
        // var infoAgreeEvent: BehaviorSubject<Bool>
        var recentSearchList: BehaviorSubject<String>
        var afterSearchEnter: PublishSubject<String>
    }
}
