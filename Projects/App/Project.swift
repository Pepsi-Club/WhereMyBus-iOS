import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(name: "App") {
    App(name: "App") {
        MainFeature()
        Data()
        FirebaseModule()
        FileManagerService()
        SwiftLintScript()
        UIKitInfoPlist()
        AppInfoPlist(displayName: .displayName, marketingVersion: .marketingVersion, buildVersion: .buildVersion)
        SecretInfoPlist()
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
