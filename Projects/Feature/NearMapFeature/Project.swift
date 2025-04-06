import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "NearMapFeature",
    options: .options(automaticSchemesOptions: .disabled)
) {
    Feature(name: "NearMapFeature") {
        FeatureDependency()
    }
    SampleApp(name: "NearMapFeature") {
        Feature(name: "NearMapFeature")
    }
    SampleAppScheme(name: "NearMapFeature")
}
