import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "ThirdPartyLibs",
    moduleType: .dynamicFramework,
    dependencies: [
        .XCFramework.NMapsGeometry,
        .XCFramework.NMapsMap,
        .SPM.RxSwift,
        .SPM.RxCocoa
    ]
)
