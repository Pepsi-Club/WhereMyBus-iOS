import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(name: "FeatureDependency") {
    FeatureDependency() {
        DesignSystem()
        Domain()
    }
}
