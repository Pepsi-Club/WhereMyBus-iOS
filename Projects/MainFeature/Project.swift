import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "MainFeature",
    moduleType: .framework,
    dependencies: .Feature.allCases.map { $0.dependency }
)
