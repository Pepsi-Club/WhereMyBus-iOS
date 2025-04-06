//
//  TestsTarget.swift
//  EnvironmentPlugin
//
//  Created by gnksbm on 4/6/25.
//

public protocol TestsTarget: TargetBuildable { }

public extension TestsTarget {
    var infoPlist: InfoPlist? { .frameworkInfoPlist }
    var sources: SourceFilesList? { ["Tests/**"] }
    var settings: Settings? {
        .settings(
            base: .baseSetting
                .setVersion()
                .setCodeSignManual()
                .setProvisioning()
                .enableTestabilty(),
            configurations: [
                .debug(
                    name: .debug,
                    xcconfig: .relativeToRoot("XCConfig/App_Debug.xcconfig")
                ),
                .release(
                    name: .release,
                    xcconfig: .relativeToRoot("XCConfig/App_Release.xcconfig")
                ),
            ],
            defaultSettings: .recommended
        )
    }
}
