import UIKit

import RxSwift

public final class SearchViewController: UIViewController {
    private let viewModel: SearchViewModel
    
    public init(viewModel: SearchViewModel) {
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
