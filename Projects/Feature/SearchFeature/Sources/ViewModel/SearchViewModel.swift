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
            recentSearchedResponse: useCase.recentSearchResult,
            nearByStopInfo: .init()
        )
        
        input.viewWillAppearEvent
            .take(1)
            .withUnretained(self)
            .subscribe(
                onNext: { vm, _ in
                    vm.useCase.updateNearByStop()
                        .bind(to: output.nearByStopInfo)
                        .disposed(by: vm.disposeBag)
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
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, text in
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
        
        input.mapBtnTapEvent
            .withUnretained(self)
            .subscribe(
                onNext: { vm, busStopId in
                    vm.coordinator.startNearMapFlow(busStopId: busStopId)
                }
            )
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
        let mapBtnTapEvent: PublishSubject<String>
    }
    
    public struct Output {
        let searchedResponse: PublishSubject<[BusStopRegion]>
        let recentSearchedResponse: BehaviorSubject<[BusStopInfoResponse]>
        let nearByStopInfo: PublishSubject<(BusStopInfoResponse, String)>
    }
}
