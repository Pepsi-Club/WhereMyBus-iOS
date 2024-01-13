import ProjectDescription
import DependencyPlugin
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "ThirdPartyLibs",
    moduleType: .framework,
    dependencies: .ThirdPartyExternal.allCases.map {
        .external(name: $0.name)
    }
)
