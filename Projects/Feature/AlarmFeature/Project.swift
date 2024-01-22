import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "AlarmFeature",
    moduleType: .feature,
    dependencies: [
        .featureDependency
    ]
)
