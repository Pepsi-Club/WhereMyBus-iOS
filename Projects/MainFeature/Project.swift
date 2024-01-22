import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "MainFeature",
    moduleType: .staticFramework,
    dependencies: .Presentation.allCases.map { $0.dependency }
)
