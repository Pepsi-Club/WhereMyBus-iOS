//
//  AppScheme.swift
//  EnvironmentPlugin
//
//  Created by gnksbm on 4/6/25.
//

public struct AppScheme: SchemeBuildable {
    public let name: String
    
    public let shared: Bool = true
    public var buildAction: BuildAction? {
        .buildAction(targets: ["\(name)"])
    }
    public var testAction: TestAction? {
        .targets(
            ["\(name)Tests"],
            configuration: .debug,
            options: .options(
                coverage: true,
                codeCoverageTargets: ["\(name)"]
            )
        )
    }
    public var runAction: RunAction? {
        .runAction(
            configuration: .debug,
            arguments: .arguments(
                launchArguments: [
                    .launchArgument(name: "-FIRDebugDisabled", isEnabled: true),
                    .launchArgument(name: "-noFIRAnalyticsDebugEnabled", isEnabled: true)
                ]
            )
        )
    }
    
    public init(name: String) {
        self.name = name
    }
}
