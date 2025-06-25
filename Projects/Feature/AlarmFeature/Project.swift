import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "AlarmFeature",
    options: .options(automaticSchemesOptions: .disabled)
) {
    Feature(name: "AlarmFeature") {
        FeatureDependency()
        FeatureSwiftLintScript()
        FrameworkInfoPlist(marketingVersion: .marketingVersion)
        SecretInfoPlist()
    }
    SampleApp(name: "AlarmFeature") {
        Feature(name: "AlarmFeature")
        UIKitInfoPlist()
        AppInfoPlist(displayName: "AlarmFeatureSampleApp", marketingVersion: .marketingVersion, buildVersion: .buildVersion)
        SecretInfoPlist()
    }
    SampleAppScheme(name: "AlarmFeature")
}
