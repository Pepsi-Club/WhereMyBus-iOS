import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(name: "DesignSystem") {
    DesignSystem {
        Lottie()
        FrameworkInfoPlist(marketingVersion: .marketingVersion)
    }
}
