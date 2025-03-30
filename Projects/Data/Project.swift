import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "Data",
    moduleType: .dynamicFramework,
    dependencies: [
        .NetworkService,
        .CoreDataService,
        .FirebaseInterface
    ],
    coreDataModel: [
        .coreDataModel(
            "../App/Resources/Model.xcdatamodeld",
            currentVersion: "Model_v2"
        )
    ]
)
