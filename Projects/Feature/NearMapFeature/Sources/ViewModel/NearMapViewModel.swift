import Foundation
import CoreLocation

import Core
import DesignSystem
import Domain
import FeatureDependency

import RxSwift
import RxRelay
import NMapsMap

public final class NearMapViewModel
: NSObject, CLLocationManagerDelegate, ViewModel {
    @Injected(NearMapUseCase.self) var useCase: NearMapUseCase
    private let coordinator: NearMapCoordinator
    private let viewMode: NearMapMode
    
    private let disposeBag = DisposeBag()
	
    public init(
        coordinator: NearMapCoordinator,
        busStopId: String?
    ) {
        self.coordinator = coordinator
        if let busStopId {
            viewMode = .focused(busStopId: busStopId)
        } else {
            viewMode = .normal
        }
	}
    /*
     NearMap
     ViewWillAppear 시점에 권한 여부에 따라 뷰 표시
     허용: 현재위치
     비허용: 네이버본사위치
     앱 설정으로 딥링크
     아직 선택 안했을 때: 권한요청창을 띄우기
     */
	deinit {
		coordinator.finish()
	}
	
	public func transform(input: Input) -> Output {
		let output = Output(
            selectedBusStopInfo: .init(),
            nearStopList: .init(),
            navigationTitle: .init(value: "주변 정류장")
		)
        
        input.viewWillAppearEvent
            .withUnretained(self)
            .bind(
                onNext: { viewModel, _ in
                    viewModel.useCase.requestAuthorize()
                    switch viewModel.viewMode {
                    case .normal:
                        viewModel.useCase.getNearByStopInfo()
                            .subscribe(
                                onNext: { selectedBusStopInfo in
                                    output.selectedBusStopInfo.onNext(
                                        selectedBusStopInfo
                                    )
                                }
                            )
                            .disposed(by: viewModel.disposeBag)
                    case .focused(let busStopId):
                        let selectedBusStopInfo = viewModel.useCase
                            .getSelectedBusStop(busStopId: busStopId)
                        output.selectedBusStopInfo.onNext(selectedBusStopInfo)
                        output.navigationTitle.accept(
                            selectedBusStopInfo.0.busStopName
                        )
                    }
                }
            )
            .disposed(by: disposeBag)
        
        input.informationViewTapEvent
            .withLatestFrom(output.selectedBusStopInfo)
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, tuple in
                    let (response, _) = tuple
                    switch viewModel.viewMode {
                    case .normal:
                        viewModel.coordinator.startBusStopFlow(
                            busStopId: response.busStopId
                        )
                    case .focused:
                        break
                    }
                }
            )
            .disposed(by: disposeBag)
        
        input.selectedBusStopId
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, busStopId in
                    guard !busStopId.isEmpty else { return }
                    let selectedStopInfo = viewModel.useCase
                        .getSelectedBusStop(busStopId: busStopId)
                    output.selectedBusStopInfo.onNext(selectedStopInfo)
                }
            )
            .disposed(by: disposeBag)
        
        input.locationChangeEvent
            .withUnretained(self)
            .map { viewModel, range in
                let (longitudeRange, latitudeRange) = range
                return viewModel.useCase.getNearBusStopList(
                    longitudeRange: longitudeRange,
                    latitudeRange: latitudeRange)
            }
            .bind(to: output.nearStopList)
            .disposed(by: disposeBag)
        
        return output
	}
}

extension NearMapViewModel {
    public struct Input {
        let viewWillAppearEvent: Observable<Void>
        let informationViewTapEvent: Observable<Void>
        let selectedBusStopId: Observable<String>
        let locationChangeEvent
        : Observable<(ClosedRange<Double>, ClosedRange<Double>)>
    }
    
    public struct Output {
        let selectedBusStopInfo: PublishSubject<(BusStopInfoResponse, String)>
        let nearStopList: PublishSubject<[BusStopInfoResponse]>
        let navigationTitle: BehaviorRelay<String>
    }
}

extension NearMapViewModel {
    private enum NearMapMode {
        case normal, focused(busStopId: String)
    }
}
