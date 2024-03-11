import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "NetworkService",
    moduleType: .staticFramework,
    dependencies: [
        .domain,
    ]
)
