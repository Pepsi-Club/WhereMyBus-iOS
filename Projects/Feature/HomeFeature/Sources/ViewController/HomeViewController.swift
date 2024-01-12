import UIKit

import RxSwift

public final class HomeViewController: UIViewController {
    private let viewModel: HomeViewModel
    
    public init(viewModel: HomeViewModel) {
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

#if DEBUG
import SwiftUI
import FeatureDependency
struct HomeViewController_Preview: PreviewProvider {
    static var previews: some View {
        UIKitPreview(
            HomeViewController(
                viewModel: HomeViewModel()
            )
        )
    }
}
#endif
