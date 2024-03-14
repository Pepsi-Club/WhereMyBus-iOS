import Foundation

import Core
import DesignSystem
import Domain
import FeatureDependency

import CoreLocation
import RxSwift
import KakaoMapsSDK

public final class NearMapViewModel
: NSObject, CLLocationManagerDelegate, ViewModel {
	@Injected(NearMapUseCase.self) var useCase: NearMapUseCase
    private let coordinator: NearMapCoordinator
    
    var mapController: KMController?
    
    private var selectedBusId = PublishSubject<String>()
    private let disposeBag = DisposeBag()
	
	public init(
        coordinator: NearMapCoordinator
    ) {
        self.coordinator = coordinator
	}
	
	deinit {
        mapController?.stopRendering()
        mapController?.stopEngine()
		coordinator.finish()
	}
	
	public func transform(input: Input) -> Output {
		let output = Output(
            selectedBusStop: useCase.nearByBusStop
		)
        
        input.viewWillAppearEvent
            .withUnretained(self)
            .bind(
                onNext: { viewModel, _ in
                    viewModel.useCase.getNearByBusStop()
                }
            )
            .disposed(by: disposeBag)
        
        input.informationViewTapEvent
            .withLatestFrom(output.selectedBusStop)
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, busStop in
                    guard !busStop.busStopId.isEmpty
                    else { return }
                    viewModel.coordinator.startBusStopFlow(
                        busStopId: busStop.busStopId
                    )
                }
            )
            .disposed(by: disposeBag)
        
//        input.kakaoMapTouchesEndedEvent
//            .withLatestFrom(
//                // MARK: 전체 1xxxx개 데이터를 넣어서 makeBusIcon에서
//                // filter해서 화면에 보이는 것들만 추가함
//                // TODO: [BusStopInfoResponse]만 리턴받으면 되고 자유롭게 수정해도 괜찮음
//                useCase.stationListRepository.searchResponse
//            ) { _, responses in
//                return responses
//            }
//            .withUnretained(self)
//            .subscribe(
//                onNext: { viewModel, responses in
//                    viewModel.makeBusIcon(
//                        responses: responses
//                    )
//                }
//            )
//            .disposed(by: disposeBag)
        
        selectedBusId
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, busStopId in
                    viewModel.useCase.busStopSelected(busStopId: busStopId)
                }
            )
            .disposed(by: disposeBag)
        
		return output
	}
    
    func initKakaoMap() {
        mapController?.delegate = self
        mapController?.initEngine()
        mapController?.startEngine()
        mapController?.authenticate()
    }
    
    private func addBusPointStyle() {
        guard let mapView = mapController?.getView("mapview") as? KakaoMap
        else { return }
        
        let labelManager = mapView.getLabelManager()
        
        let layerOption = LabelLayerOptions(
            layerID: "busStopLayer",
            competitionType: .none,
            competitionUnit: .poi,
            orderType: .rank,
            zOrder: 10001
        )
        _ = labelManager.addLabelLayer(option: layerOption)
        
        let busIconStyle = PoiIconStyle(
            symbol: UIImage(systemName: "bus")?
                .withTintColor(DesignSystemAsset.accentColor.color),
            anchorPoint: CGPoint(
                x: 0.0,
                y: 0.5
            )
        )
        let busPerLevelStyle = PerLevelPoiStyle(
            iconStyle: busIconStyle,
            level: 0
        )
        let busPoiStyle = PoiStyle(
            styleID: "busStop",
            styles: [busPerLevelStyle]
        )
        labelManager.addPoiStyle(busPoiStyle)
    }
    
    private func makeBusIcon(responses: [BusStopInfoResponse]) {
        guard let mapView = mapController?.getView("mapview") as? KakaoMap
        else { return }
        
        let layer = mapView.getLabelManager()
            .getLabelLayer(layerID: "busStopLayer")
        
        let viewMaxPoint = CGPoint(
            x: mapView.viewRect.size.width,
            y: mapView.viewRect.size.height
        )
        let minLatitude = mapView.getPosition(viewMaxPoint).wgsCoord.latitude
        let maxLatitude = mapView.getPosition(.zero).wgsCoord.latitude
        let minLongitude = mapView.getPosition(.zero).wgsCoord.longitude
        let maxLongitude = mapView.getPosition(viewMaxPoint).wgsCoord.longitude
        
        responses
            .filter { response in
                guard let longitude = Double(response.longitude),
                      let latitude = Double(response.latitude)
                else { return false }
                return minLatitude...maxLatitude ~= latitude &&
                minLongitude...maxLongitude ~= longitude
            }
            .forEach { response in
                guard layer?.getPoi(poiID: response.busStopId) == nil
                else { return }
                let poiOption = PoiOptions(
                    styleID: "busStop",
                    poiID: response.busStopId
                )
                poiOption.rank = 0
                poiOption.clickable = true
                guard let longitude = Double(response.longitude),
                      let latitude = Double(response.latitude)
                else { return }
                let poi1 = layer?.addPoi(
                    option: poiOption,
                    at: MapPoint(
                        longitude: longitude,
                        latitude: latitude
                    )
                )
                _ = poi1?.addPoiTappedEventHandler(
                    target: self,
                    handler: NearMapViewModel.poiTappedHandler
                )
                poi1?.show()
            }
    }
    
    private func poiTappedHandler(_ param: PoiInteractionEventParam) {
        selectedBusId.onNext(param.poiItem.itemID)
    }
}

extension NearMapViewModel: MapControllerDelegate {
	public func addViews() {
		
		let defaultPosition = MapPoint(
			longitude: 127.108678,
			latitude: 37.402001
		)
		let mapviewInfo = MapviewInfo(
			viewName: "mapview",
			appName: "openmap",
			viewInfoName: "map",
			defaultPosition: defaultPosition,
			defaultLevel: 7
		)
				
		if mapController?.addView(mapviewInfo) == Result.OK {
            addBusPointStyle()
		}
	}
	
	public func authenticationSucceeded() {
        mapController?.startRendering()
	}
	
	public func containerDidResized(_ size: CGSize) {
        guard let mapView = mapController?.getView("mapview") as? KakaoMap
        else { return }
        mapView.viewRect = CGRect(
            origin: CGPoint(x: 0.0, y: 0.0),
            size: size
        )
    }
}

extension NearMapViewModel {
    public struct Input {
        let viewWillAppearEvent: Observable<Void>
        let kakaoMapTouchesEndedEvent: Observable<Void>
        let informationViewTapEvent: Observable<Void>
    }
    
    public struct Output {
        let selectedBusStop: PublishSubject<BusStopInfoResponse>
    }
}
