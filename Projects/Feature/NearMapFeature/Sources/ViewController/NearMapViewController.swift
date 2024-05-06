import UIKit
import Domain

import DesignSystem

import RxSwift
import RxCocoa
import NMapsMap

public final class NearMapViewController: UIViewController {
    private let viewModel: NearMapViewModel
    
    private let cameraMoveEvent =
    PublishSubject<(ClosedRange<Double>, ClosedRange<Double>)>()
    private let disposeBag = DisposeBag()
    
    private lazy var builder: NMCBuilder<BusStopClusteringKey> = {
        let builder = NMCBuilder<BusStopClusteringKey>()
        builder.leafMarkerUpdater = viewModel
        builder.maxZoom = 16
        return builder
    }()
    
    private lazy var clusterer: NMCClusterer<BusStopClusteringKey> = {
        let clusterer = builder.build()
        clusterer.mapView = naverMap.mapView
        return clusterer
    }()
    
    private lazy var naverMap: NMFNaverMapView = {
        let mapView = NMFNaverMapView()
        mapView.clipsToBounds = true
        mapView.layer.cornerRadius = 15
        mapView.mapView.addCameraDelegate(delegate: self)
        mapView.showLocationButton = true
        mapView.mapView.zoomLevel = 18
        return mapView
    }()
    
    private let busStopInformationView: BusStopInformationView = {
        let view = BusStopInformationView()
        view.clipsToBounds = false
        view.layer.cornerRadius = 15
        return view
    }()
    
    init(viewModel: NearMapViewModel) {
        self.viewModel = viewModel
        super.init(
            nibName: nil,
            bundle: nil
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        clusterer.clear()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        bind()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if navigationController?.isNavigationBarHidden == true {
            navigationController?.setNavigationBarHidden(
                false,
                animated: true
            )
        }
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(
            true,
            animated: true
        )
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        [busStopInformationView, naverMap].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            busStopInformationView.bottomAnchor.constraint(
                equalTo: safeArea.bottomAnchor,
                constant: -10
            ),
            busStopInformationView.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor,
                constant: 7
            ),
            busStopInformationView.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor,
                constant: -7
            ),
            busStopInformationView.heightAnchor.constraint(
                equalToConstant: 130
            ),
            
            naverMap.topAnchor.constraint(
                equalTo: safeArea.topAnchor
            ),
            naverMap.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor,
                constant: 7
            ),
            naverMap.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor,
                constant: -7
            ),
            naverMap.bottomAnchor.constraint(
                equalTo: busStopInformationView.topAnchor,
                constant: -10
            ),
        ])
    }
    
    private func bind() {
        let tapGesture = UITapGestureRecognizer()
        busStopInformationView.addGestureRecognizer(tapGesture)
        
        let output = viewModel.transform(
            input: .init(
                viewWillAppearEvent: rx
                    .methodInvoked(#selector(UIViewController.viewWillAppear))
                    .map { _ in },
                informationViewTapEvent: tapGesture.rx.event.map { _ in },
                locationChangeEvent: cameraMoveEvent
            )
        )
        
        output.selectedBusStopInfo
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(
                onNext: { vc, tuple in
                    let (response, distance) = tuple
                    vc.busStopInformationView.updateUI(
                        response: response,
                        distance: distance
                    )
                    vc.moveCamera(response: response)
                }
            )
            .disposed(by: disposeBag)
        
        output.nearStopList
            .withUnretained(self)
            .subscribe(
                onNext: { vc, responses in
                    vc.drawMarker(responses: responses)
                }
            )
            .disposed(by: disposeBag)
        
        output.navigationTitle
            .withUnretained(self)
            .subscribe(
                onNext: { viewController, title in
                    viewController.navigationItem.title = title
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func moveCamera(response: BusStopInfoResponse) {
        guard let latitude = Double(response.latitude),
              let longitude = Double(response.longitude)
        else { return }
        let location = NMGLatLng(
            lat: latitude,
            lng: longitude
        )
        let cameraUpdate = NMFCameraUpdate(
            position: .init(
                location,
                zoom: naverMap.mapView.zoomLevel
            )
        )
        let distance = location.distance(
            to: naverMap.mapView.cameraPosition.target
        )
        cameraUpdate.animation = distance > 10000 ? .none : .easeOut
        cameraUpdate.animationDuration = 1
        naverMap.mapView.moveCamera(cameraUpdate)
    }
    
    private func drawMarker(responses: [BusStopInfoResponse]) {
        var keyTagMap = [AnyHashable: NSObject]()
        responses.forEach { response in
            guard let latitude = Double(response.latitude),
                  let longitude = Double(response.longitude),
                  let busStopIdInt = Int(response.busStopId)
            else { return }
            let location = NMGLatLng(
                lat: latitude,
                lng: longitude
            )
            let itemKey = BusStopClusteringKey(
                identifier: busStopIdInt,
                position: location
            )
            guard !clusterer.contains(itemKey)
            else { return }
            keyTagMap[itemKey] = NSNull()
        }
        clusterer.addAll(keyTagMap)
    }
}

extension NearMapViewController: NMFMapViewCameraDelegate {
    public func mapView(
        _ mapView: NMFMapView,
        cameraDidChangeByReason reason: Int,
        animated: Bool
    ) {
        guard let location1 = mapView.coveringBounds.boundsLatLngs.first,
              let location2 = mapView.coveringBounds.boundsLatLngs.last
        else { return }
        let longitude1 = location1.lng
        let latitude1 = location1.lat
        let longitude2 = location2.lng
        let latitude2 = location2.lat
        
        let longitudeRange = longitude1 < longitude2 ?
        longitude1...longitude2 : longitude2...longitude1
        let latitudeRange = latitude2 < latitude1 ?
        latitude2...latitude1 : latitude1...latitude2
        cameraMoveEvent.onNext((longitudeRange, latitudeRange))
    }
}
