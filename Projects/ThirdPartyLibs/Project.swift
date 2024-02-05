import ProjectDescription
import DependencyPlugin
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "ThirdPartyLibs",
    moduleType: .dynamicFramework,
    packages: [
        .remote(
            url: "https://github.com/kakao-mapsSDK/KakaoMapsSDK-SPM",
            requirement: .branch("master")
        )
    ],
    dependencies: .ThirdPartyExternal.allCases.map {
        .external(name: $0.name)
    } + [.package(product: "KakaoMapsSDK_SPM")]
)
