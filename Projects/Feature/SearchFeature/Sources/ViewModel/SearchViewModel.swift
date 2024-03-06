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

    // MARK: 더 효율적으로 할 순 없나??
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
            infoAgreeEvent: .init(value: false),
            enterPressedEvent: .init())
        
        input.viewWillAppearEvenet
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, _ in
                    viewModel.useCase.getRecentSearches()
                })
            .disposed(by: disposeBag)
        
        // 수정된 부분
        input.enterPressedSubject
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, _ in
                    self.handleEnterPressed()
                }
            )
            .disposed(by: disposeBag)
        

        // MARK: 질문 이 메서드에 문제가 있는 것 같은데 이유를 모르겠습니다
        //        input.busStopTapEvent
        //            .withUnretained(self)
        //            .subscribe(
        //                onNext: { viewModel, index in
        //                    do {
        //                        let response = try viewModel.useCase
        //                            .busStopInfoResponse
        //                        viewModel.coordinator.startBusStopFlow(stationId: response[index].first)
        //                    }
        //                    catch {
        //                        print(error.localizedDescription)
        //                    }
        //                }
        //            )
        //            .disposed(by: disposeBag)
        
        return output
    }
}

extension SearchViewModel {
    public struct Input {
        let viewWillAppearEvenet: Observable<Void>
        let infoAgreeEvent: Observable<Bool>
        let busStopTapEvent: Observable<Int>
        let enterPressedSubject: Observable<Void>
    }
    
    public struct Output {
        var infoAgreeEvent: BehaviorSubject<Bool>
        var enterPressedEvent: PublishSubject<Void>
    }
}
