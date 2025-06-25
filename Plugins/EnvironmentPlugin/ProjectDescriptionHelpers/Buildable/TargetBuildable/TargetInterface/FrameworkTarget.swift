//
//  FrameworkTarget.swift
//  ProjectDescriptionHelpers
//
//  Created by gnksbm on 4/6/25.
//

public protocol FrameworkTarget: ImplementTarget, TypeNameContains { }

public extension FrameworkTarget {
    var scripts: [TargetScript] {
        [
            TargetScript.pre(
                path: .relativeToRoot("Scripts/SwiftLintRunScript.sh"),
                name: "SwiftLintShell",
                basedOnDependencyAnalysis: false
            )
        ]
    }
    var targetDependencyPath: Path { .relativeToRoot("Projects/\(name)") }
}
