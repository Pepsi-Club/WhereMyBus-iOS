import ProjectDescription
import DependencyPlugin
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "App",
    moduleType: .app,
    entitlementsPath: .relativeToManifest("App.entitlements"),
    hasResource: true,
    appExtensionTarget: [
        Project.appExtensionTarget(
            name: "NotificationExtension",
            plist: .notificationInfoPlist,
            dependencies: [
                .data
            ]
        )
    ],
    dependencies: [
        .mainFeature,
        .data,
    ]
)
