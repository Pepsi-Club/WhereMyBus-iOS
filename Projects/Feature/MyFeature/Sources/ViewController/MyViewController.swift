import UIKit

import RxSwift

public final class MyViewController: UIViewController {
    private let viewModel: MyViewModel
    
    public init(viewModel: MyViewModel) {
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
struct MyViewController_Preview: PreviewProvider {
    static var previews: some View {
        UIKitPreview(
            MyViewController(
                viewModel: MyViewModel()
            )
        )
    }
}
#endif
