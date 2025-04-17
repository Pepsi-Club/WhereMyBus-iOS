import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "HomeFeature",
    options: .options(automaticSchemesOptions: .disabled)
) {
    Feature(name: "HomeFeature") {
        FeatureDependency()
        FeatureSwiftLintScript()
        FrameworkInfoPlist(marketingVersion: .marketingVersion)
        SecretInfoPlist()
    }
    SampleApp(name: "HomeFeature") {
        Feature(name: "HomeFeature")
        UIKitInfoPlist()
        AppInfoPlist(displayName: "HomeFeatureSampleApp", marketingVersion: .marketingVersion, buildVersion: .buildVersion)
        SecretInfoPlist()
    }
    SampleAppScheme(name: "HomeFeature")
}
