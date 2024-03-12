import Foundation

import Core
import Domain
import FeatureDependency

import CoreLocation
import RxSwift
import KakaoMapsSDK

public final class NearMapViewModel: NSObject,
									 CLLocationManagerDelegate,
									 ViewModel {
	
	// MARK: - DI Property
	
	@Injected(NearBusStopUseCase.self) var useCase: NearBusStopUseCase
	private let coordinator: NearMapCoordinator
	
	// MARK: - Property
	
	var mapController: KMController?
	
	private let disposeBag = DisposeBag()
	
	// MARK: - Life Cycle
	
	public init(coordinator: NearMapCoordinator) {
		self.coordinator = coordinator
		
	}
	
	deinit {
		coordinator.finish()
	}
	
	// MARK: - Function
	
	public func transform(input: Input) -> Output {
		let output = Output(
			busStopName: .init(value: "강남구 보건소"),
			busStomNumber: .init(value: "23290"),
			busStopDescription: .init(value: "강남구청역 방면")
			
		)
		return output
	}
	
}

extension NearMapViewModel {
	public struct Input {
		let selectBusStop: Observable<Void>
		let moveToBusStopDetailView: Observable<Void>
	}
	
	public struct Output {
		let busStopName: BehaviorSubject<String>
		let busStomNumber: BehaviorSubject<String>
		let busStopDescription: BehaviorSubject<String>
	}
}

// MARK: - Extension MapControllerDelegate

extension NearMapViewModel: MapControllerDelegate {
	
	public func initKakaoMap() {
		mapController?.delegate = self
		mapController?.initEngine()
		mapController?.startEngine()
		mapController?.startRendering()
		mapController?.authenticate()
	}
	
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
			print("KMcontroller에 추가 성공")
			
			createPoi()
		}
	}
	
	public func authenticationSucceeded() {
		print("auth")
	}
	
	public func authenticate() {
		
	}
	
	public func containerDidResized(_ size: CGSize) {
		let mapView: KakaoMap? = mapController?.getView("mapview") as? KakaoMap
			mapView?.viewRect = CGRect(
				origin: CGPoint(x: 0.0, y: 0.0),
				size: size
			)
		}
	
	func createPoi() {
		
		// MARK: - Create Layer
		
		let view = mapController?.getView("mapview") as? KakaoMap
		let manager = view?.getLabelManager()
		
		let layerOption = LabelLayerOptions(
			layerID: "PoiLayer",
			competitionType: .none,
			competitionUnit: .poi,
			orderType: .rank,
			zOrder: 10001
		)
		let _ = manager?.addLabelLayer(option: layerOption)
		
		// MARK: - Add Poi Style
		
		let iconStyle = PoiIconStyle(
			symbol: UIImage(systemName: "bus"),
			anchorPoint: CGPoint(x: 0.0, y: 0.5)
		)
		let perLevelStyle = PerLevelPoiStyle(iconStyle: iconStyle, level: 0)
		let poiStyle = PoiStyle(
			styleID: "customStyle1",
			styles: [perLevelStyle]
		)
		manager?.addPoiStyle(poiStyle)

		// MARK: - Add Poi
		
		let layer = manager?.getLabelLayer(layerID: "PoiLayer")
		let poiOption = PoiOptions(styleID: "customStyle1")
		poiOption.rank = 0
		poiOption.clickable = true
		
		let poi1 = layer?.addPoi(
			option: poiOption,
			at: MapPoint(
				longitude: 127.108678,
				latitude: 37.402001
			), callback: {(_ poi: (Poi?)) -> Void in }
		)
		let _ = poi1?.addPoiTappedEventHandler(
			target: self,
			handler: NearMapViewModel.poiTappedHandler
		)
		
		poi1?.show()
	}
	
	func poiTappedHandler(_ param: PoiInteractionEventParam) {
		print("\(param.poiItem)")
	}
}
