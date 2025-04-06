import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "SettingsFeature",
    options: .options(automaticSchemesOptions: .disabled)
) {
    Feature(name: "SettingsFeature") {
        FeatureDependency()
    }
    SampleApp(name: "SettingsFeature") {
        Feature(name: "SettingsFeature")
    }
    SampleAppScheme(name: "SettingsFeature")
}
