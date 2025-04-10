import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "AlarmFeature",
    options: .options(automaticSchemesOptions: .disabled)
) {
    Feature(name: "AlarmFeature") {
        FeatureDependency()
        FeatureSwiftLintScript()
    }
    SampleApp(name: "AlarmFeature") {
        Feature(name: "AlarmFeature")
    }
    SampleAppScheme(name: "AlarmFeature")
}
