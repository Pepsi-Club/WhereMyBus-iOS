import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(name: "ThirdPartyLibs") {
    ThirdPartyLibs {
        // TODO: NaverMap을 사용하지 않는 모듈에서 의존성하지 않도록
        NMapsGeometry()
        NMapsMap()
        RxSwift()
        RxCocoa()
        FrameworkInfoPlist(marketingVersion: .marketingVersion)
    }
}
