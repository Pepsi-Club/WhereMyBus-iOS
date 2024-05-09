import UIKit

import Core
import DesignSystem
import Domain
import FeatureDependency

import RxSwift
import RxRelay
import NMapsMap

public final class NearMapViewModel: LeafMarkerUpdater, ViewModel {
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
                    if case .focused(let busStopId) = viewModel.viewMode {
                        let selectedBusStopInfo = viewModel.useCase
                            .getSelectedBusStop(busStopId: busStopId)
                        viewModel
                            .selectedBusStopId.onNext(busStopId)
                        output.navigationTitle.accept(
                            selectedBusStopInfo.0.busStopName
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
                    if case .normal = viewModel.viewMode {
                        viewModel.useCase.getNearByStopInfo()
                            .subscribe(
                                onNext: { selectedBusStopInfo in
                                    viewModel.selectedBusStopId
                                        .onNext(selectedBusStopInfo.0.busStopId)
                                }
                            )
                            .disposed(by: viewModel.disposeBag)
                    }
                }
            )
            .disposed(by: disposeBag)
        
        input.informationViewTapEvent
            .withLatestFrom(output.selectedBusStopInfo)
            .withLatestFrom(useCase.locationStatus) { tuple, status in
                (tuple, status)
            }
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, tuple in
                    let ((response, _), status) = tuple
                    switch viewModel.viewMode {
                    case .normal:
                        switch status {
                        case .denied, .error:
                            guard let url = URL(
                                string: UIApplication
                                    .openSettingsURLString
                            )
                            else { return }
                            UIApplication.shared.open(url)
                        case .notDetermined:
                            viewModel.useCase.requestAuthorize()
                        default:
                            guard !response.busStopId.isEmpty
                            else { return }
                            viewModel.coordinator.startBusStopFlow(
                                busStopId: response.busStopId
                            )
                        }
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
        
        selectedBusStopId
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
        
        return output
	}
}

extension NearMapViewModel {
    public struct Input {
        let viewWillAppearEvent: Observable<Void>
        let informationViewTapEvent: Observable<Void>
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
