////
////  SampleBasicKMViewController.swift
////  NearMapFeature
////
////  Created by Muker on 2/5/24.
////  Copyright © 2024 Pepsi-Club. All rights reserved.
////

//import UIKit
//import KakaoMapsSDK
//
//public class APISampleBaseViewController: UIViewController,
//										  MapControllerDelegate {
//	
//	init() {
//		observerAdded = false
//		auth = false
//		appear = false
//		super.init(nibName: nil, bundle: nil)
//	}
//	
//	required init?(coder: NSCoder) {
//		fatalError("init(coder:) has not been implemented")
//	}
//	
//	deinit {
//		mapController?.stopRendering()
//		mapController?.stopEngine()
//		
//		print("deinit")
//	}
//	
//	public override func viewDidLoad() {
//		
//		super.viewDidLoad()
//		mapContainer = KMViewContainer(frame: CGRect(x: 10, y: 10, width: 100, height: 100))
//		
//		// KMController 생성.
//		mapController = KMController(viewContainer: mapContainer!)!
//		mapController!.delegate = self
//		print("- \(mapController?.description)")
//		self.view.accessibilityIdentifier = "KMViewContainer"
//		mapController?.initEngine() // 엔진 초기화. 엔진 내부 객체 생성 및 초기화가 진행된다.
//	
//	}
//
//	public override func viewWillAppear(_ animated: Bool) {
//		addObservers()
//		appear = true
//		if mapController?.engineStarted == false {
//			mapController?.startEngine()
//		}
//		
//		if mapController?.rendering == false {
//			mapController?.startRendering()
//		}
//	}
//	
//	public override func viewDidAppear(_ animated: Bool) {
//		
//	}
//	
//	public override func viewWillDisappear(_ animated: Bool) {
//		appear = false
//		mapController?.stopRendering()  // 렌더링 중지.
//	}
//
//	public override func viewDidDisappear(_ animated: Bool) {
//		removeObservers()
//		mapController?.stopEngine()     // 엔진 정지. 추가되었던 ViewBase들이 삭제된다.
//	}
//	
//	// 인증 성공시 delegate 호출.
//	public func authenticationSucceeded() {
//		// 일반적으로 내부적으로 인증과정 진행하여 성공한 경우 별도의 작업은 필요하지 않으나,
//		// 네트워크 실패와 같은 이슈로 인증실패하여 인증을 재시도한 경우, 성공한 후 정지된 엔진을 다시 시작할 수 있다.
//		if auth == false {
//			auth = true
//		}
//		
//		if mapController?.engineStarted == false {
//			mapController?.startEngine()    
//			// 엔진 시작 및 렌더링 준비.
//			// 준비가 끝나면 MapControllerDelegate의 addViews 가 호출된다.
//			mapController?.startRendering() // 렌더링 시작.
//		}
//	}
//	
//	// 인증 실패시 호출.
//	public func authenticationFailed(_ errorCode: Int, desc: String) {
//		print("error code: \(errorCode)")
//		print("desc: \(desc)")
//		auth = false
//		switch errorCode {
//		case 400:
//			showToast(self.view, message: "지도 종료(API인증 파라미터 오류)")
//		case 401:
//			showToast(self.view, message: "지도 종료(API인증 키 오류)")
//		case 403:
//			showToast(self.view, message: "지도 종료(API인증 권한 오류)")
//		case 429:
//			showToast(self.view, message: "지도 종료(API 사용쿼터 초과)")
//		case 499:
//			showToast(self.view, message: "지도 종료(네트워크 오류) 5초 후 재시도..")
//			
//			// 인증 실패 delegate 호출 이후 5초뒤에 재인증 시도..
//			DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
//				print("retry auth...")
//				
//				self.mapController?.authenticate()
//			}
//		default:
//			break
//		}
//	}
//	
//	public func addViews() {
//		// 여기에서 그릴 View(KakaoMap, Roadview)들을 추가한다.
//		let defaultPosition: MapPoint = MapPoint(
//			longitude: 127.108678,
//			latitude: 37.402001
//		)
//		// 지도(KakaoMap)를 그리기 위한 viewInfo를 생성
//		let mapviewInfo: MapviewInfo = MapviewInfo(
//			viewName: "mapview",
//			viewInfoName: "map",
//			defaultPosition: defaultPosition,
//			defaultLevel: 7
//		)
//		
//		// KakaoMap 추가.
//		if mapController?.addView(mapviewInfo) == Result.OK {
//			print("OK") // 추가 성공. 성공시 추가적으로 수행할 작업을 진행한다.
//		}
//	}
//	
//	// Container 뷰가 리사이즈 되었을때 호출된다.
//	// 변경된 크기에 맞게 ViewBase들의 크기를 조절할 필요가 있는 경우 여기에서 수행한다.
//	public func containerDidResized(_ size: CGSize) {
//		let mapView: KakaoMap? = mapController?.getView("mapview") as? KakaoMap
//		mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
//		// 지도뷰의 크기를 리사이즈된 크기로 지정한다.
//	}
//	
//	public func viewWillDestroyed(_ view: ViewBase) {
//		
//	}
//	
//	func addObservers() {
//		NotificationCenter.default.addObserver(
//			self,
//			selector: #selector(willResignActive),
//			name: UIApplication.willResignActiveNotification,
//			object: nil
//		)
//		NotificationCenter.default.addObserver(
//			self,
//			selector: #selector(didBecomeActive),
//			name: UIApplication.didBecomeActiveNotification,
//			object: nil
//		)
//	
//		observerAdded = true
//	}
//	 
//	func removeObservers() {
//		NotificationCenter.default.removeObserver(
//			self,
//			name: UIApplication.willResignActiveNotification,
//			object: nil
//		)
//		NotificationCenter.default.removeObserver(
//			self,
//			name: UIApplication.didBecomeActiveNotification,
//			object: nil
//		)
//
//		observerAdded = false
//	}
//
//	@objc func willResignActive() {
//		mapController?.stopRendering()
//		// 뷰가 inactive 상태로 전환되는 경우 렌더링 중인 경우 렌더링을 중단.
//	}
//
//	@objc func didBecomeActive() {
//		mapController?.startRendering()
//		// 뷰가 active 상태가 되면 렌더링 시작. 엔진은 미리 시작된 상태여야 함.
//	}
//	
//	func showToast(_ view: UIView, message: String, duration: TimeInterval = 2.0) {
//		let toastLabel = UILabel(
//			frame: CGRect(
//				x: view.frame.size.width/2 - 150,
//				y: view.frame.size.height-100,
//				width: 300,
//				height: 35
//			)
//		)
//		toastLabel.backgroundColor = UIColor.black
//		toastLabel.textColor = UIColor.white
//		toastLabel.textAlignment = NSTextAlignment.center
//		view.addSubview(toastLabel)
//		toastLabel.text = message
//		toastLabel.alpha = 1.0
//		toastLabel.layer.cornerRadius = 10
//		toastLabel.clipsToBounds  =  true
//		
//		UIView.animate(withDuration: 0.4,
//					   delay: duration - 0.4,
//					   options: UIView.AnimationOptions.curveEaseOut,
//					   animations: { toastLabel.alpha = 0.0 },
//					   completion: { _ in toastLabel.removeFromSuperview() }
//		)
//	}
//	
//	var mapContainer: KMViewContainer?
//	var mapController: KMController?
//	var observerAdded: Bool
//	var auth: Bool
//	var appear: Bool
//}
