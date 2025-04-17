import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "BusStopFeature",
    options: .options(automaticSchemesOptions: .disabled)
) {
    Feature(name: "BusStopFeature") {
        FeatureDependency()
        FeatureSwiftLintScript()
        FrameworkInfoPlist(marketingVersion: .marketingVersion)
        SecretInfoPlist()
    }
    SampleApp(name: "BusStopFeature") {
        Feature(name: "BusStopFeature")
        UIKitInfoPlist()
        AppInfoPlist(displayName: "BusStopFeatureSampleApp", marketingVersion: .marketingVersion, buildVersion: .buildVersion)
        SecretInfoPlist()
    }
    SampleAppScheme(name: "BusStopFeature")
}
