import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(name: "App") {
    App(name: "App") {
        MainFeature()
        Data()
        FirebaseModule()
    }
//    WidgetExtension(name: "Widget") {
//        MainFeature()
//        Data()
//    }
    AppScheme(name: "App")
    UnitTestsScheme(targetName: "App")
    UITestsScheme(targetName: "App")
}
