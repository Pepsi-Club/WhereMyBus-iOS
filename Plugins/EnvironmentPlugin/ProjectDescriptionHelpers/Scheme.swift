//
//  Scheme.swift
//  EnvironmentPlugin
//
//  Created by gnksbm on 2024/01/13.
//

import ProjectDescription

public extension Scheme {
    static func moduleScheme(name: String) -> Self {
        Scheme(
            name: name,
            shared: true,
            buildAction: .buildAction(targets: ["\(name)"]),
            testAction: .targets(
                ["\(name)Tests"],
                configuration: .debug,
                options: .options(
                    coverage: true,
                    codeCoverageTargets: ["\(name)"]
                )
            ),
            runAction: .runAction(configuration: .debug),
            archiveAction: .archiveAction(configuration: .release)
        )
    }
    
    static func uiTestsScheme(name: String) -> Self {
        Scheme(
            name: "\(name)UITests",
            shared: true,
            buildAction: .buildAction(targets: ["\(name)"]),
            testAction: .targets(
                ["\(name)UITests"],
                configuration: .debug,
                options: .options(
                    coverage: true,
                    codeCoverageTargets: ["\(name)UITests"]
                )
            ),
            runAction: .runAction(configuration: .debug),
            archiveAction: .archiveAction(configuration: .release)
        )
    }
    
    static func appDebugScheme(name: String) -> Self {
        Scheme(
            name: "\(name)-FirebaseDebug",
            shared: true,
            buildAction: .buildAction(targets: ["\(name)-FirebaseDebug"]),
            runAction: .runAction(
                configuration: .debug, 
                arguments: Arguments(
                    launchArguments: [
                        .init(name: "-FIRDebugEnabled", isEnabled: true)
                    ]
                )
            ),
            // TODO: 검토필요
            archiveAction: .archiveAction(configuration: .debug)
        )
    }
}
