import UIKit

import Domain
import Core
import FeatureDependency

import RxSwift

public final class SearchViewModel: ViewModel {
    private let coordinator: SearchCoordinator
    
    @Injected(SearchUseCase.self) var useCase: SearchUseCase
    
    private let disposeBag = DisposeBag()

    public init(coordinator: SearchCoordinator) {
        self.coordinator = coordinator
    }
    
    deinit {
        coordinator.finish()
    }
    
    public func transform(input: Input) -> Output {
        let output = Output(
            afterSearchEnter: .init(),
            jsontoSearchResponse: .init(value: .init([])),
            recentSearchResultResponse: .init(value: .init([]))
        )
        
        input.viewWillAppearEvenet
            .withUnretained(self)
            .subscribe(
                // MARK: 필요없을수도
                onNext: { viewModel, _ in
                    viewModel.useCase.getRecentSearchList()
                })
            .disposed(by: disposeBag)
        
        input.enterPressedEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, textfield in
                    viewModel.coordinator.goAfterSearchView(text: textfield)
                }
            )
            .disposed(by: disposeBag)
        
        input.backbtnEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, _ in
                    viewModel.coordinator.popVC()
                }
            )
            .disposed(by: disposeBag)
        
        //MARK: 여기 map을 이런식으로 넣은 이유?
        useCase.jsontoSearchData
            .withUnretained(self)
            .map { (owner, result) in
                return result
            }
            .bind(to: output.jsontoSearchResponse)
            .disposed(by: disposeBag)
        
        useCase.recentSearchResult
            .withUnretained(self)
            .map { (owner, result) in
                return result
            }
            .bind(to: output.recentSearchResultResponse)
            .disposed(by: disposeBag)
        
        return output
    }
}

extension SearchViewModel {
    enum InfoAgreeState {
        case agree, disagree
    }
}

extension SearchViewModel {
    public struct Input {
        let viewWillAppearEvenet: Observable<Void>
//        let infoAgreeEvent: Observable<Bool>
        let enterPressedEvent: Observable<String>
        let backbtnEvent: Observable<Void>
//        let cellTapEvent: Observable<String>
    }
    
    public struct Output {
        // var infoAgreeEvent: BehaviorSubject<Bool>
        var afterSearchEnter: PublishSubject<String>
        var jsontoSearchResponse
        : BehaviorSubject<[BusStopInfoResponse]>
        var recentSearchResultResponse
        : BehaviorSubject<[BusStopInfoResponse]>
    }
}
