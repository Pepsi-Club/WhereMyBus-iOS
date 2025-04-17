//
//  WidgetExtension.swift
//  EnvironmentPlugin
//
//  Created by gnksbm on 4/6/25.
//

public struct WidgetExtension: AppExtensionTarget {
    public let name: String
    public let dependencies: [TargetDependency]
    
    public let infoPlist: InfoPlist?
    public let scripts: [TargetScript]
    
    public var sources: SourceFilesList? { ["\(name)/**"] }
    public var resources: ResourceFileElements? {
        [
            "Resources/Model.xcdatamodeld",
            "Resources/total_stationList.json",
            "Widget/Resources/**",
        ]
    }
    public var entitlements: Entitlements? {
        .file(path: .relativeToRoot("Projects/App/Widget.entitlements"))
    }
    public var settings: Settings? {
        Settings.settings(
            base: .init()
                .setCodeSignManual()
                .setProvisioning(),
            configurations: [
                .debug(
                    name: .debug,
                    xcconfig: .relativeToRoot("XCConfig/\(name)_Debug.xcconfig")
                ),
                .release(
                    name: .release,
                    xcconfig: .relativeToRoot("XCConfig/\(name)_Release.xcconfig")
                ),
            ]
        )
    }
    public var bundleIDSuffix: String { name }
    
    public init(
        name: String,
        @TargetComponentBuilder dependencies builder: () -> TargetComponentBuilder
    ) {
        let builder = builder()
        self.name = name
        self.dependencies = builder.buildTargetDependency()
        self.scripts = builder.buildTargetScript()
        self.infoPlist = builder.buildInfoPlist()
    }
}
