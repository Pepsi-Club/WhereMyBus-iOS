import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "AlarmFeature",
    options: .options(automaticSchemesOptions: .disabled)
) {
    FeatureInterface(name: "AlarmFeature") {
        FeatureDependency()
        FeatureSwiftLintScript()
        FrameworkInfoPlist(marketingVersion: .marketingVersion)
    }
    FeatureImplement(name: "AlarmFeature") {
        FeatureInterface(name: "AlarmFeature")
        FeatureSwiftLintScript()
        FrameworkInfoPlist(marketingVersion: .marketingVersion)
    }
    FeatureTesting(name: "AlarmFeature") {
        FeatureImplement(name: "AlarmFeature")
        FeatureSwiftLintScript()
        FrameworkInfoPlist(marketingVersion: .marketingVersion)
        SecretInfoPlist()
    }
    SampleApp(name: "AlarmFeature") {
        Feature(name: "AlarmFeature")
        UIKitInfoPlist()
        AppInfoPlist(
            displayName: "AlarmFeatureSampleApp",
            marketingVersion: .marketingVersion,
            buildVersion: .buildVersion
        )
        SecretInfoPlist()
    }
    SampleAppScheme(name: "AlarmFeature")
}
