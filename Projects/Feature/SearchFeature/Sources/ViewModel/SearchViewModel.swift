import UIKit

import Domain
import Core
import FeatureDependency

import RxSwift
import RxRelay

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
            searchedResponse: useCase.searchedStationList,
            recentSearchResultResponse: .init(),
            nearByStop: .init(),
            tableViewSection: .init(value: .recentSearch)
        )
        
        input.viewWillAppearEvenet
            .withUnretained(self)
            .subscribe(
                // MARK: 필요없을수도
                onNext: { viewModel, _ in
                    viewModel.useCase.getRecentSearchList()
                }
            )
            .disposed(by: disposeBag)
        
        input.removeBtnTapEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, _ in
                    print(viewModel)
                }
            )
            .disposed(by: disposeBag)
        
        input.enterPressedEvent
            .withLatestFrom(output.tableViewSection) { text, section in
                return (text, section)
            }
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, tuple in
                    let (text, section) = tuple
                    viewModel.useCase.search(term: text)
                    switch section {
                    case .recentSearch:
                        if !text.isEmpty {
                            output.tableViewSection.accept(.searchedData)
                        }
                    case .searchedData:
                        if text.isEmpty {
                            output.tableViewSection.accept(.recentSearch)
                        }
                    }
                }
            )
            .disposed(by: disposeBag)
        
        input.cellTapEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, busStopId in
                    viewModel.coordinator.startBusStopFlow(stationId: busStopId)
                }
            )
            .disposed(by: disposeBag)
        
        useCase.recentSearchResult
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
        let enterPressedEvent: Observable<String>
        let removeBtnTapEvent: Observable<Void>
        let nearBusStopTapEvent: Observable<Void>
        let cellTapEvent: Observable<String>
    }
    
    public struct Output {
        var searchedResponse: PublishSubject<[BusStopInfoResponse]>
        var recentSearchResultResponse: PublishSubject<[BusStopInfoResponse]>
        var nearByStop: PublishSubject<BusStopInfoResponse>
        var tableViewSection: BehaviorRelay<SearchSection>
    }
}
