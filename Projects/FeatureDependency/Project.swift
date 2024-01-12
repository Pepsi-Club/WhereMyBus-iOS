import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "FeatureDependency",
    moduleType: .framework,
    dependencies: [
        .domain,
        .designSystem
    ]
)
