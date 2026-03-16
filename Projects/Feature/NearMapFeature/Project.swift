import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "NearMapFeature",
    options: .options(automaticSchemesOptions: .disabled)
) {
    Feature(name: "NearMapFeature") {
        FeatureDependency()
        FeatureSwiftLintScript()
        FrameworkInfoPlist(marketingVersion: .marketingVersion)
        SecretInfoPlist()
    }
    SampleApp(name: "NearMapFeature") {
        Feature(name: "NearMapFeature")
        UIKitInfoPlist()
        AppInfoPlist(
            displayName: "NearMapFeatureSampleApp",
            marketingVersion: .marketingVersion,
            buildVersion: .buildVersion
        )
        SecretInfoPlist()
    }
    SampleAppScheme(name: "NearMapFeature")
}
