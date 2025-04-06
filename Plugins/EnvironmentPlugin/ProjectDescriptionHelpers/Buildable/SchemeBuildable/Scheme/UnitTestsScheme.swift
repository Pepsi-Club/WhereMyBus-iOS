//
//  UnitTestsScheme.swift
//  EnvironmentPlugin
//
//  Created by gnksbm on 4/6/25.
//

public struct UnitTestsScheme: SchemeBuildable {
    public let targetName: String
    
    public var name: String { "\(targetName)Tests" }
    public let shared: Bool = true
    public var buildAction: BuildAction? {
        .buildAction(targets: ["\(targetName)"])
    }
    public var testAction: TestAction? {
        .targets(
            ["\(name)"],
            configuration: .debug,
            options: .options(
                coverage: true,
                codeCoverageTargets: ["\(targetName)"]
            )
        )
    }
    
    public init(targetName: String) {
        self.targetName = targetName
    }
}
