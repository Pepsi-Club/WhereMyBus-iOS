import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "Core",
    moduleType: .dynamicFramework,
    dependencies: [
        .ThirdPartyLibs
    ]
)
