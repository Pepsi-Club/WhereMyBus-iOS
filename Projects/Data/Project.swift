import ProjectDescription
import DependencyPlugin
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "Data",
    moduleType: .staticFramework,
    dependencies: [
        .networks
    ]
)
