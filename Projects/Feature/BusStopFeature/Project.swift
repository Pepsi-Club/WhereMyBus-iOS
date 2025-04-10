import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "BusStopFeature",
    options: .options(automaticSchemesOptions: .disabled)
) {
    Feature(name: "BusStopFeature") {
        FeatureDependency()
        FeatureSwiftLintScript()
    }
    SampleApp(name: "BusStopFeature") {
        Feature(name: "BusStopFeature")
    }
    SampleAppScheme(name: "BusStopFeature")
}
