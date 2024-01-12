import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "MapFeature",
    moduleType: .feature,
    dependencies: [
        .featureDependency
    ]
)
