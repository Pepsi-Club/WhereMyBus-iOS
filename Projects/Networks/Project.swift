import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "Networks",
    moduleType: .staticFramework,
    dependencies: [
        .domain,
    ]
)
