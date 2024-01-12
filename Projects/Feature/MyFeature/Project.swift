import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "MyFeature",
    moduleType: .feature,
    dependencies: [
        .featureDependency
    ]
)
