import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "BusStopFeature",
    moduleType: .feature,
    dependencies: [
        .featureDependency
    ]
)
