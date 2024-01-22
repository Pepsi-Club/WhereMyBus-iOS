import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "SearchFeature",
    moduleType: .feature,
    dependencies: [
        .featureDependency
    ]
)
