//
//  SwiftLintScript.swift
//  EnvironmentPlugin
//
//  Created by gnksbm on 4/11/25.
//

public struct SwiftLintScript: PreTargetScriptBuildable {
    public let path: Path = .relativeToRoot("Scripts/SwiftLintRunScript.sh")
    public let name: String = "SwiftLintShell"
    
    public init() { }
}
