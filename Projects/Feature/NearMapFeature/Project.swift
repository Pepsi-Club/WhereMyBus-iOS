import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "NearMapFeature",
    moduleType: .feature,
    dependencies: [
        .featureDependency
    ]
)
