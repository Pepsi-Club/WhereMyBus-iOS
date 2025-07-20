import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "BusStopFeature",
    options: .options(automaticSchemesOptions: .disabled)
) {
    Feature(name: "BusStopFeature") {
        FeatureInterface(name: "NearMapFeature")
        FeatureInterface(name: "AlarmFeature")
        FeatureDependency()
        FeatureSwiftLintScript()
        FrameworkInfoPlist(marketingVersion: .marketingVersion)
        SecretInfoPlist()
    }
    SampleApp(name: "BusStopFeature") {
        Feature(name: "BusStopFeature")
        Feature(name: "NearMapFeature")
        FeatureTesting(name: "AlarmFeature")
        UIKitInfoPlist()
        AppInfoPlist(
            displayName: "BusStopFeatureSampleApp",
            marketingVersion: .marketingVersion,
            buildVersion: .buildVersion
        )
        SecretInfoPlist()
    }
    SampleAppScheme(name: "BusStopFeature")
}
