//
//  SchemeBuildable.swift
//  EnvironmentPlugin
//
//  Created by gnksbm on 4/6/25.
//

public protocol SchemeBuildable {
    var name: String { get }
    var shared: Bool { get }
    var hidden: Bool { get }
    var buildAction: BuildAction? { get }
    var testAction: TestAction? { get }
    var runAction: RunAction? { get }
    var archiveAction: ArchiveAction? { get }
    var profileAction: ProfileAction? { get }
    var analyzeAction: AnalyzeAction? { get }
}

public extension SchemeBuildable {
    var shared: Bool { true }
    var hidden: Bool { false }
    var buildAction: BuildAction? { nil }
    var testAction: TestAction? { nil }
    var runAction: RunAction? { .runAction(configuration: .debug) }
    var archiveAction: ArchiveAction? { .archiveAction(configuration: .release) }
    var profileAction: ProfileAction? { nil }
    var analyzeAction: AnalyzeAction? { nil }
    
    func buildScheme() -> Scheme {
        .scheme(
            name: name,
            shared: shared,
            hidden: hidden,
            buildAction: buildAction,
            testAction: testAction,
            runAction: runAction,
            archiveAction: archiveAction,
            profileAction: profileAction,
            analyzeAction: analyzeAction
        )
    }
}
