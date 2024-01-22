import UIKit

import RxSwift

public final class SettingsViewController: UIViewController {
    private let viewModel: SettingsViewModel
    
    public init(viewModel: SettingsViewModel) {
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
