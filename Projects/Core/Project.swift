import ProjectDescription
import DependencyPlugin
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "Core",
    moduleType: .dynamicFramework,
    dependencies: [
        .thirdPartyLibs
    ]
)
