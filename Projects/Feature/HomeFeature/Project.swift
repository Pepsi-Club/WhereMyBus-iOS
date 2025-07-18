import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "HomeFeature",
    options: .options(automaticSchemesOptions: .disabled)
) {
    FeatureInterface(name: "HomeFeature") {
        FeatureDependency()
        FeatureSwiftLintScript()
        FrameworkInfoPlist(marketingVersion: .marketingVersion)
    }
    FeatureImplement(name: "HomeFeature") {
        FeatureInterface(name: "HomeFeature")
        FeatureSwiftLintScript()
        FrameworkInfoPlist(marketingVersion: .marketingVersion)
        SecretInfoPlist()
    }
    SampleApp(name: "HomeFeature") {
        Feature(name: "HomeFeature")
        UIKitInfoPlist()
        AppInfoPlist(
            displayName: "HomeFeatureSampleApp",
            marketingVersion: .marketingVersion,
            buildVersion: .buildVersion
        )
        SecretInfoPlist()
    }
    SampleAppScheme(name: "HomeFeature")
}
