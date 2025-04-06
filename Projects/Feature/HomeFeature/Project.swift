import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "HomeFeature",
    options: .options(automaticSchemesOptions: .disabled)
) {
    Feature(name: "HomeFeature") {
        FeatureDependency()
    }
    SampleApp(name: "HomeFeature") {
        Feature(name: "HomeFeature")
    }
    SampleAppScheme(name: "HomeFeature")
}
