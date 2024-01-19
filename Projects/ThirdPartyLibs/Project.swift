import ProjectDescription
import DependencyPlugin
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "ThirdPartyLibs",
    moduleType: .dynamicFramework,
    dependencies: .ThirdPartyExternal.allCases.map {
        .external(name: $0.name)
    }
)
