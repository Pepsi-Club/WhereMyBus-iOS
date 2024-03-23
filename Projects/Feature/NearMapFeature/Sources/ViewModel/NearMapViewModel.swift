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
    
    private var selectedBusId = PublishSubject<String>()
    private var nearStopList = PublishSubject<[BusStopInfoResponse]>()
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
                        output.selectedBusStopInfo.onNext(
                            viewModel.useCase.getSelectedBusStop(
                                busStopId: busStopId
                            )
                        )
                    }
                }
            )
            .disposed(by: disposeBag)
        
        input.viewWillAppearEvent
            .take(1)
            .withUnretained(self)
            .bind(
                onNext: { viewModel, _ in
                }
            )
            .disposed(by: disposeBag)
        
        input.viewWillDisappearEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, _ in
                }
            )
            .disposed(by: disposeBag)
        
        input.selectedBusStopId
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, busStopId in
                    switch viewModel.viewMode {
                    case .normal:
                        guard !busStopId.isEmpty else { return }
                        let selectedStopInfo = viewModel.useCase
                            .getSelectedBusStop(busStopId: busStopId)
                        output.selectedBusStopInfo.onNext(selectedStopInfo)
                    case .focused:
                        break
                    }
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
        
        input.kakaoMapTouchesEndedEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, _ in
                }
            )
            .disposed(by: disposeBag)
        
        selectedBusId
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, busStopId in
                    switch viewModel.viewMode {
                    case .normal:
                        let selectedStopInfo = viewModel.useCase
                            .getSelectedBusStop(busStopId: busStopId)
                        output.selectedBusStopInfo.onNext(selectedStopInfo)
                    case .focused:
                        break
                    }
                }
            )
            .disposed(by: disposeBag)
        
        output.selectedBusStopInfo
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, tuple in
                    let (selectedBusStop, _) = tuple
                    guard let longitude = Double(selectedBusStop.longitude),
                          let latitude = Double(selectedBusStop.latitude)
                    else { return }
                    switch viewModel.viewMode {
                    case .normal:
                        break
                    case .focused:
                        output.navigationTitle.accept(
                            selectedBusStop.busStopName
                        )
                    }
                }
            )
            .disposed(by: disposeBag)
        
        nearStopList
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, responses in
                }
            )
            .disposed(by: disposeBag)
        
//        Timer.scheduledTimer(
//            withTimeInterval: 1,
//            repeats: false
//        ) { [weak self] timer in
//            guard let self else { return }
//            switch viewMode {
//            case .normal:
//                useCase.getNearByStopInfo()
//                    .subscribe(
//                        onNext: { selectedBusStopInfo in
//                            output.selectedBusStopInfo.onNext(
//                                selectedBusStopInfo
//                            )
//                        }
//                    )
//                    .disposed(by: disposeBag)
//            case .focused(let busStopId):
//                output.selectedBusStopInfo.onNext(
//                    useCase.getSelectedBusStop(busStopId: busStopId)
//                )
//            }
//            timer.invalidate()
//        }
        
        return output
	}
}

extension NearMapViewModel {
    public struct Input {
        let viewWillAppearEvent: Observable<Void>
        let viewWillDisappearEvent: Observable<Void>
        let kakaoMapTouchesEndedEvent: Observable<Void>
        let informationViewTapEvent: Observable<Void>
        let selectedBusStopId: Observable<String>
        let locationChangeEvent:
        Observable<(ClosedRange<Double>, ClosedRange<Double>)>
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
