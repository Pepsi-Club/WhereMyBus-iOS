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
            recentSearchedResponse: .init(),
            nearByStop: .init(),
            tableViewSection: .init(value: .recentSearch)
        )
        
        input.viewWillAppearEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, _ in
                    do {
                        let nearByStopInfo = try viewModel.useCase.fetchNearByStop()
                        output.nearByStop.onNext(nearByStopInfo)
                    } catch {
                        print(error.localizedDescription)
                    }
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
        
        input.textFieldChangeEvent
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
        
        input.nearByStopTapEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, _ in
                    viewModel.coordinator.startNearMapFlow()
                }
            )
            .disposed(by: disposeBag)
        
        useCase.recentSearchResult
            .bind(to: output.recentSearchedResponse)
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
        let cellTapEvent: Observable<String>
    }
    
    public struct Output {
        var searchedResponse: PublishSubject<[BusStopInfoResponse]>
        var recentSearchedResponse: PublishSubject<[BusStopInfoResponse]>
        var nearByStop: PublishSubject<(BusStopInfoResponse, String)>
        var tableViewSection: BehaviorRelay<SearchSection>
    }
}
