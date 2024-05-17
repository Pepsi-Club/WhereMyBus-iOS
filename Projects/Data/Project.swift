import ProjectDescription
import DependencyPlugin
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "Data",
    moduleType: .dynamicFramework,
    dependencies: [
        .networkService,
        .coreDataService,
        .package(product: "FirebaseAnalytics"),
    ],
    coreDataModel: [
        .init(
            "../App/Resources/Model.xcdatamodeld",
            currentVersion: "Model_v2"
        )
    ]
)
