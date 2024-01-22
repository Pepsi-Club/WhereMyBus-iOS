import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "HomeFeature",
    moduleType: .feature,
    dependencies: [
        .featureDependency
    ]
)
