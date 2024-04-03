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
            recentSearchedResponse: .init(value: []),
            nearByStopInfo: .init(),
            tableViewSection: .init(value: .recentSearch)
        )
        
        input.viewWillAppearEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, _ in
                    viewModel.useCase.updateNearByStop()
                }
            )
            .disposed(by: disposeBag)
        
        input.removeBtnTapEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, _ in
                    viewModel.useCase.removeRecentSearch()
                }
            )
            .disposed(by: disposeBag)
        
        input.textFieldChangeEvent
            .withLatestFrom(output.tableViewSection) { text, section in
                return (text, section)
            }
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, tuple in
                    let (text, section) = tuple
                    switch section {
                    case .recentSearch:
                        if !text.isEmpty {
                            output.tableViewSection.accept(.searchedStop)
                        }
                    case .searchedStop:
                        if text.isEmpty {
                            output.tableViewSection.accept(.recentSearch)
                        }
                    }
                    viewModel.useCase.search(term: text)
                }
            )
            .disposed(by: disposeBag)
        
        input.cellTapEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, response in
                    viewModel.useCase.saveRecentSearch(response: response)
                    viewModel.coordinator.startBusStopFlow(
                        stationId: response.busStopId
                    )
                }
            )
            .disposed(by: disposeBag)
        
        input.nearByStopTapEvent
            .withLatestFrom(useCase.locationStatus)
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, status in
                    switch status {
                    case .notDetermined:
                        viewModel.useCase.requestAuthorize()
                    default:
                        viewModel.coordinator.startNearMapFlow()
                    }
                }
            )
            .disposed(by: disposeBag)
        
        useCase.recentSearchResult
            .bind(to: output.recentSearchedResponse)
            .disposed(by: disposeBag)
        
        useCase.nearByStopInfo
            .bind(to: output.nearByStopInfo)
            .disposed(by: disposeBag)
        
        return output
    }
}

extension SearchViewModel {
    public struct Input {
        let viewWillAppearEvent: Observable<Void>
        let textFieldChangeEvent: Observable<String>
        let removeBtnTapEvent: Observable<Void>
        let nearByStopTapEvent: Observable<Void>
        let cellTapEvent: Observable<BusStopInfoResponse>
    }
    
    public struct Output {
        var searchedResponse: PublishSubject<[BusStopInfoResponse]>
        var recentSearchedResponse: BehaviorSubject<[BusStopInfoResponse]>
        var nearByStopInfo: PublishSubject<(BusStopInfoResponse, String)>
        var tableViewSection: BehaviorRelay<SearchSection>
    }
}
