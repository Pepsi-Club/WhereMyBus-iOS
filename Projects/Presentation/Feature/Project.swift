import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "Feature",
    moduleType: .dynamicFramework,
    additionalPath: "Presentation",
    dependencies: [
        .presentationDependency
    ]
)
