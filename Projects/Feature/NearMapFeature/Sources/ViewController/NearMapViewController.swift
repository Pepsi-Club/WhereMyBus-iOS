import UIKit

import RxSwift

public final class NearMapViewController: UIViewController {
    private let viewModel: NearMapViewModel
    
    public init(viewModel: NearMapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
}
