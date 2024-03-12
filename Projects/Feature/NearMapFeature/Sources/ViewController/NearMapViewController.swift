import UIKit

import DesignSystem

import KakaoMapsSDK
import RxSwift
import RxCocoa

public final class NearMapViewController: UIViewController {
	
	// MARK: - Property
	
	private let viewModel: NearMapViewModel
	
	private var disposeBag = DisposeBag()
	
	// MARK: - UI Property
	
	private var kakaoMap: KMViewContainer = {
		var view = KMViewContainer()
		view.clipsToBounds = true
		view.layer.cornerRadius = 15
		return view
	}()
	
	private let nearBusStopLabel: NearBusStopLabel = {
		var label = NearBusStopLabel()
		label.clipsToBounds = true
		label.layer.cornerRadius = 15
		return label
	}()
	
	private lazy var separationView: UIView = {
		let view = UIView()
		view.backgroundColor = .black
		return view
	}()
	
	// MARK: - View Cycle
	
	deinit {
		print("\(Self.description()) 해제")
	}
	
	init(
		viewModel: NearMapViewModel
	) {
		self.viewModel = viewModel
		
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		
		viewModel.mapController = KMController(viewContainer: kakaoMap)
		viewModel.initKakaoMap()
		configureUI()
		bind()
	}
	
	// MARK: - Function
	
	public func configureUI() {
		
		self.navigationItem.title = "주변 정류장"
		self.navigationController!.navigationBar.titleTextAttributes = [
			.font: DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(
				size: 16
			)
		]
		
		view.backgroundColor = .white
		
		[
			separationView,
			kakaoMap,
			nearBusStopLabel,
		].forEach {
			view.addSubview($0)
			$0.translatesAutoresizingMaskIntoConstraints = false
		}
		
		NSLayoutConstraint.activate([
			
			// separationView
			separationView.topAnchor.constraint(
				equalTo: view.safeAreaLayoutGuide.topAnchor,
				constant: 0
			),
			separationView.leftAnchor.constraint(
				equalTo: view.safeAreaLayoutGuide.leftAnchor,
				constant: 0
			),
			separationView.rightAnchor.constraint(
				equalTo: view.safeAreaLayoutGuide.rightAnchor,
				constant: 0
			),
			separationView.heightAnchor.constraint(
				equalToConstant: 0.2
			),
			
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
				equalTo: separationView.safeAreaLayoutGuide.topAnchor,
				constant: 8
			),
			kakaoMap.bottomAnchor.constraint(
				equalTo: nearBusStopLabel.topAnchor,
				constant: -10
			),
			kakaoMap.leftAnchor.constraint(
				equalTo: view.safeAreaLayoutGuide.leftAnchor,
				constant: 5
			),
			kakaoMap.rightAnchor.constraint(
				equalTo: view.safeAreaLayoutGuide.rightAnchor,
				constant: -5
			),
			
		])
	}
	
	private func bind() {
		let labelTapGesture = UITapGestureRecognizer()
		nearBusStopLabel.addGestureRecognizer(labelTapGesture)
		
		labelTapGesture.rx.event
			.bind(onNext: { _ in
				print("버스정류장 detail View로 넘어가기")
			})
			.disposed(by: disposeBag)
		
		let output = viewModel.transform(input:
				.init(
					selectBusStop: .just({}()),
					moveToBusStopDetailView: labelTapGesture.rx.event.map { _ in }
				)
		)
		
		output.busStopName
			.bind(to: nearBusStopLabel.busStopNameLabel.rx.text)
			.disposed(by: disposeBag)
	}
	
}
