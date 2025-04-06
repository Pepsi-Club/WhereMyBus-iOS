import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(name: "MainFeature") {
    MainFeature {
        Feature(name: "HomeFeature")
        Feature(name: "AlarmFeature")
        Feature(name: "SettingsFeature")
        Feature(name: "BusStopFeature")
        Feature(name: "SearchFeature")
        Feature(name: "NearMapFeature")
    }
}
