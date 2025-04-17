import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "SearchFeature",
    options: .options(automaticSchemesOptions: .disabled)
) {
    Feature(name: "SearchFeature") {
        FeatureDependency()
        FeatureSwiftLintScript()
        FrameworkInfoPlist(marketingVersion: .marketingVersion)
        SecretInfoPlist()
    }
    SampleApp(name: "SearchFeature") {
        Feature(name: "SearchFeature")
        UIKitInfoPlist()
        AppInfoPlist(displayName: "SearchFeatureSampleApp", marketingVersion: .marketingVersion, buildVersion: .buildVersion)
        SecretInfoPlist()
    }
    SampleAppScheme(name: "SearchFeature")
}
