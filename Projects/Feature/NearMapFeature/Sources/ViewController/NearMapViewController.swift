import UIKit

import KakaoMapsSDK

import RxSwift

public final class NearMapViewController: UIViewController,
										  MapControllerDelegate {
	
	private let viewModel: NearMapViewModel
	
	var kakaoMap = KMViewContainer()
	var mapController: KMController?
	var observerAdded = false
	var auth = false
	var appear = false
	
	private let nearBusStopLabel: NearBusStopLabel = {
		var label = NearBusStopLabel()
		label.clipsToBounds = true
		label.layer.cornerRadius = 15
		return label
	}()
	
	init(viewModel: NearMapViewModel, kakaoMap: KMViewContainer) {
		self.viewModel = viewModel
		self.kakaoMap = kakaoMap
		
		super.init(nibName: nil, bundle: nil)
	}
	
	// MARK: - viewCylce
	
	deinit {
		mapController?.stopRendering()
		mapController?.stopEngine()
		
		print("deinit")
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public override func viewDidLoad() {
		
		super.viewDidLoad()
		
		self.navigationItem.title = "가까운 버스정류장 찾기"
		
		mapController = KMController(viewContainer: kakaoMap)
		mapController!.delegate = self
		mapController?.initEngine()
		
		configureUI()
		
	}
	
	public override func viewWillAppear(_ animated: Bool) {
		//		addObservers()
		appear = true
		if mapController?.engineStarted == false {
			mapController?.startEngine()
		}
		
		if mapController?.rendering == false {
			mapController?.startRendering()
		}
	}
	
	public override func viewWillDisappear(_ animated: Bool) {
		appear = false
		mapController?.stopRendering()
	}
	
	public override func viewDidDisappear(_ animated: Bool) {
		mapController?.stopEngine()
	}
	
	// MARK: - setUI
	
	public func configureUI() {
		view.backgroundColor = .white
		
		[
			kakaoMap,
			nearBusStopLabel,
		].forEach {
			view.addSubview($0)
			$0.translatesAutoresizingMaskIntoConstraints = false
		}
		
		NSLayoutConstraint.activate([
			
			// NearBusStopLabel
			nearBusStopLabel.bottomAnchor.constraint(
				equalTo: view.safeAreaLayoutGuide.bottomAnchor,
				constant: -10
			),
			nearBusStopLabel.leftAnchor.constraint(
				equalTo: view.safeAreaLayoutGuide.leftAnchor,
				constant: 10
			),
			nearBusStopLabel.rightAnchor.constraint(
				equalTo: view.safeAreaLayoutGuide.rightAnchor,
				constant: -10
			),
			nearBusStopLabel.heightAnchor.constraint(
				equalToConstant: 130
			),
			
			// kakaoMap
			kakaoMap.topAnchor.constraint(
				equalTo: view.safeAreaLayoutGuide.topAnchor,
				constant: 0
			),
			kakaoMap.bottomAnchor.constraint(
				equalTo: nearBusStopLabel.topAnchor,
				constant: -10
			),
			kakaoMap.leftAnchor.constraint(
				equalTo: view.safeAreaLayoutGuide.leftAnchor,
				constant: 0
			),
			kakaoMap.rightAnchor.constraint(
				equalTo: view.safeAreaLayoutGuide.rightAnchor,
				constant: 0
			),
			
		])
	}
	
	// MARK: - kakaoMap
	
	public func authenticationSucceeded() {
		if auth == false && appear {
			auth = true
			mapController?.startEngine()
			mapController?.startRendering()
		}
	}
	
	// 인증 실패시 호출.
//	public func authenticationFailed(_ errorCode: Int, desc: String) {
//		print("error code: \(errorCode)")
//		print("desc: \(desc)")
//		auth = false
//		switch errorCode {
//			case 400: 
//				showToast(self.view, message: "지도 종료(API인증 파라미터 오류)")
//			case 401:
//				showToast(self.view, message: "지도 종료(API인증 키 오류)")
//			case 403:
//				showToast(self.view, message: "지도 종료(API인증 권한 오류)")
//			case 429:
//				showToast(self.view, message: "지도 종료(API 사용쿼터 초과)")
//			case 499:
//				showToast(self.view, message: "지도 종료(네트워크 오류) 5초 후 재시도..")
//				
//				// 인증 실패 delegate 호출 이후 5초뒤에 재인증 시도..
//				DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
//					print("retry auth...")
//					
//					self.mapController?.authenticate()
//				}
//			default: break
//		}
//	}
	
	public func addViews() {
		
		let defaultPosition = MapPoint(
			longitude: 127.041924,
			latitude: 37.516348
		)
		
		let mapviewInfo = MapviewInfo(
			viewName: "mapview",
			viewInfoName: "map",
			defaultPosition: defaultPosition,
			defaultLevel: 8
		)
		
		if mapController?.addView(mapviewInfo) == Result.OK {
			print("맵 추가")
		}
	}
	
	public func containerDidResized(_ size: CGSize) {
		
		let mapView: KakaoMap? = mapController?
			.getView("mapview") as? KakaoMap
		
		mapView?.viewRect = CGRect(
			origin: CGPoint(x: 0.0, y: 0.0),
			size: size
		)
	}
	
	public func viewWillDestroyed(_ view: ViewBase) {
		
	}
	
	@objc func willResignActive() {
		mapController?.stopRendering()
	}
	
	@objc func didBecomeActive() {
		mapController?.startRendering()
	}
	
	
	
}
