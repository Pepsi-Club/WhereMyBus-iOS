import Foundation

import Domain
import Core
import FeatureDependency

import RxSwift

public final class AfterSearchViewModel: ViewModel {
    
    public let coordinator: SearchCoordinator
    
    @Injected(SearchUseCase.self) var useCase: SearchUseCase
    
    private let disposeBag = DisposeBag()

    private let texts: String
    
    public init(
        coordinator: SearchCoordinator,
        texts: String
    ) {
        self.coordinator = coordinator
        self.texts = texts
    }
    
    deinit {
        coordinator.finish()
    }
    
    public func transform(input: Input) -> Output {
        let output = Output(
            jsontoSearchResponse: .init(),
            filterdData: .init()
        )
        
        input.viewWillAppearEvenet
            .withUnretained(self)
            .subscribe(onNext: { _, _ in
                
            })
            .disposed(by: disposeBag)
        
        input.backBtnTapEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, _ in
                    viewModel.coordinator.popVC()
                })
            .disposed(by: disposeBag)

        input.cellTapEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, indexPath in
//                    viewModel.coordinator.startBusStopFlow(stationId: indexPath.row.stationId)
                })
            .disposed(by: disposeBag)

        return output
    }
}

extension AfterSearchViewModel {
    public struct Input {
        let viewWillAppearEvenet: Observable<Void>
        let backBtnTapEvent: Observable<Void>
        let cellTapEvent: Observable<IndexPath>
    }
    
    // 필터링은 유즈케이스에 잇고, 그거를 뷰모델에서 호출 하면서 필터링 된 배열을 뷰에 반영한다 . 그럴러면
    // 뷰 모델 아웃풋에 저장프로퍼티로 하고 써야한다.
    
    public struct Output {
        let jsontoSearchResponse: PublishSubject<[BusStopInfoResponse]>
        let filterdData:
            PublishSubject<[BusStopInfoResponse]>
    }
}

/*
 input.cellSelectTapEvent
             .withLatestFrom(
                 output.busStopArrivalInfoResponse
             ) { indexPath, busStopInfo in
                 return (busStopInfo.buses[indexPath.row], busStopInfo)
             }
             .withUnretained(self)
             .subscribe(onNext: { viewModel, arg1 in
                 let (busInfo, busStopInfo) = arg1
                 viewModel.useCase.update(
                     busStopInfo: busStopInfo,
                     busInfo: busInfo
                 )
                 viewModel.coordinator.moveToRegualrAlarm()
             })
             .disposed(by: disposeBag)
 */
