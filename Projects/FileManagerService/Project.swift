import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(name: "FileManagerService") {
    FileManagerService {
        Domain()
        FrameworkInfoPlist(marketingVersion: .marketingVersion)
    }
}
