import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "MainFeature",
    moduleType: .dynamicFramework,
    dependencies: [
        .Home,
        .Alarm,
        .Settings,
        .BusStop,
        .Search,
        .NearMap
    ]
)
