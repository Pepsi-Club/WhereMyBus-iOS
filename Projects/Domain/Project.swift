import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "Domain",
    moduleType: .dynamicFramework,
    dependencies: [
        .Core
    ]
)
