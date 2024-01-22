import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "FeatureDependency",
    moduleType: .dynamicFramework,
    dependencies: [
        .designSystem,
        .domain
    ]
)
