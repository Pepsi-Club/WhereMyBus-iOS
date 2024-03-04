import ProjectDescription
import DependencyPlugin
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "Data",
    moduleType: .staticFramework,
    dependencies: [
        .networks,
        .coreDataService
    ],
    coreDataModel: [
        .init("../App/Resources/Model.xcdatamodeld")
    ]
)
