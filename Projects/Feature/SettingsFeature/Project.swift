import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "SettingsFeature",
    options: .options(automaticSchemesOptions: .disabled)
) {
    Feature(name: "SettingsFeature") {
        FeatureDependency()
        FeatureSwiftLintScript()
        FrameworkInfoPlist(marketingVersion: .marketingVersion)
        SecretInfoPlist()
    }
    SampleApp(name: "SettingsFeature") {
        Feature(name: "SettingsFeature")
        UIKitInfoPlist()
        AppInfoPlist(displayName: "SettingsFeatureSampleApp", marketingVersion: .marketingVersion, buildVersion: .buildVersion)
        SecretInfoPlist()
    }
    SampleAppScheme(name: "SettingsFeature")
}
