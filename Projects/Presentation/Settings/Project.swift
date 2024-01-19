import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "Settings",
    moduleType: .presentation,
    dependencies: [
        .presentationDependency
    ]
)
