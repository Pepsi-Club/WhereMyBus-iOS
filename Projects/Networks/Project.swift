import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "Networks",
    moduleType: .framework,
    isTestable: true,
    dependencies: [
        .domain,
    ]
)
