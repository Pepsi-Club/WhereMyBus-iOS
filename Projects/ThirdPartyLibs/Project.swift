import ProjectDescription
import DependencyPlugin
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "ThirdPartyLibs",
    moduleType: .dynamicFramework,
    dependencies: .thirdPartyExternal + .thirdPartyXCFramework
)
