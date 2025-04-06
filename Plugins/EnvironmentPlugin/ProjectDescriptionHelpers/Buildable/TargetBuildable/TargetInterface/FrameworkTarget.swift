//
//  FrameworkTarget.swift
//  ProjectDescriptionHelpers
//
//  Created by gnksbm on 4/6/25.
//

public protocol FrameworkTarget: ImplementTarget, TypeNameContains { }

public extension FrameworkTarget {
    var scripts: [TargetScript] { [.swiftLint] }
    var targetDependencyPath: Path { .relativeToRoot("Projects/\(name)") }
}
