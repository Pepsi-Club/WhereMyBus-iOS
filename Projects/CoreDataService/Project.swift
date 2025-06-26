import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(name: "CoreDataService") {
    CoreDataService {
        Domain()
        FrameworkInfoPlist(marketingVersion: .marketingVersion)
    }
}
