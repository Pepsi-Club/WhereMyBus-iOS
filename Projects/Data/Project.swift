import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(name: "Data") {
    Data {
        Domain()
        NetworkService()
        CoreDataService()
        FirebaseInterface()
        FileManagerService()
        FrameworkInfoPlist(marketingVersion: .marketingVersion)
    }
}
