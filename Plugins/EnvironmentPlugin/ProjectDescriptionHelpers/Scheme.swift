//
//  Scheme.swift
//  EnvironmentPlugin
//
//  Created by gnksbm on 2024/01/13.
//

import ProjectDescription

public extension Scheme {
    static func moduleScheme(name: String) -> Self {
        Scheme.scheme(
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
            runAction: .runAction(
                configuration: .debug,
                arguments: .arguments(
                    launchArguments: [
                        .launchArgument(
                            name: "-FIRDebugEnabled",
                            isEnabled: true
                        )
                    ]
                )
            ),
            archiveAction: .archiveAction(configuration: .release)
        )
    }
    
    static func uiTestsScheme(name: String) -> Self {
        Scheme.scheme(
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
}
