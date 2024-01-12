import ProjectDescription
import DependencyPlugin
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "Domain",
    moduleType: .framework,
    dependencies: [
        .core
    ]
)
