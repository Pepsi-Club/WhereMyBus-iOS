import Foundation

import Domain
import FeatureDependency

import RxSwift

public final class HomeViewModel: ViewModel {
    private let disposeBag = DisposeBag()
    
    public init() {
    }
    
    public func transform(input: Input) -> Output {
        let output = Output()
        return output
    }
}

extension HomeViewModel {
    public struct Input {
        let viewDidLoadEvent: Observable<Void>
        let searchBtnTapEvent: Observable<Void>
        let refreshBtnTapEvent: Observable<Void>
        let likeBtnTapEvent: Observable<IndexPath>
        let alarmBtnTapEvent: Observable<IndexPath>
        let stationTapEvent: Observable<Int>
    }
    
    public struct Output {
    }
}
