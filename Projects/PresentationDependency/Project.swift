import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "PresentationDependency",
    moduleType: .dynamicFramework,
    dependencies: [
        .designSystem,
        .domain
    ]
)
