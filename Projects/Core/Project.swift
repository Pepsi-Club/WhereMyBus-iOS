import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(name: "Core") {
    Core {
        ThirdPartyLibs()
        FrameworkInfoPlist(marketingVersion: .marketingVersion)
    }
}
