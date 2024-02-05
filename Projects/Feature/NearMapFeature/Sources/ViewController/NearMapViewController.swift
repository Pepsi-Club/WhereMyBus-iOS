import UIKit

import KakaoMapsSDK
import KakaoMapsSDK_SPM

import RxSwift

public final class NearMapViewController: UIViewController,
										  MapControllerDelegate {
	public func addViews() {
	}
	
	private let viewModel: NearMapViewModel
	
	init(viewModel: NearMapViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public override func viewDidLoad() {
		
		super.viewDidLoad()
		let kmvc = KMViewContainer()
		let kmc = KMController(viewContainer: kmvc)
		kmc?.delegate = self
		kmc?.initEngine()
	}

}
