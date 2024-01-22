import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "SettingsFeature",
    moduleType: .feature,
    dependencies: [
        .featureDependency
    ]
)
