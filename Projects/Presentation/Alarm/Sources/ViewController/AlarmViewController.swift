import UIKit

import RxSwift

public final class AlarmViewController: UIViewController {
    private let viewModel: AlarmViewModel
    
    public init(viewModel: AlarmViewModel) {
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
