import ProjectDescription
import DependencyPlugin
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "Core",
    moduleType: .framework,
    dependencies: [
        .thirdPartyLibs
    ]
)
