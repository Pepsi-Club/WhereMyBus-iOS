import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "SearchFeature",
    options: .options(automaticSchemesOptions: .disabled)
) {
    Feature(name: "SearchFeature") {
        FeatureDependency()
    }
    SampleApp(name: "SearchFeature") {
        Feature(name: "SearchFeature")
    }
    SampleAppScheme(name: "SearchFeature")
}
