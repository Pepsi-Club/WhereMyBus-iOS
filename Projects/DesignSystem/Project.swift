import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "DesignSystem",
    moduleType: .framework,
    hasResource: true,
    dependencies: [
        .core
    ]
)
