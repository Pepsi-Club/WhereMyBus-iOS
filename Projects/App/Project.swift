import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(name: "App") {
    App(name: "App") {
        MainFeature()
        Data()
        FirebaseModule()
        SwiftLintScript()
    }
//    WidgetExtension(name: "Widget") {
//        MainFeature()
//        Data()
//        SwiftLintScript()
//    }
    AppScheme(name: "App")
    UnitTestsScheme(targetName: "App")
    UITestsScheme(targetName: "App")
}
