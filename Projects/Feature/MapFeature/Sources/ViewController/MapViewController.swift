import UIKit

import RxSwift

public final class MapViewController: UIViewController {
    private let viewModel: MapViewModel
    
    public init(viewModel: MapViewModel) {
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
struct MapViewController_Preview: PreviewProvider {
    static var previews: some View {
        UIKitPreview(
            MapViewController(
                viewModel: MapViewModel()
            )
        )
    }
}
#endif
