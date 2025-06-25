//
//  FeatureSwiftLintScript.swift
//  EnvironmentPlugin
//
//  Created by gnksbm on 4/11/25.
//

public struct FeatureSwiftLintScript: PreTargetScriptBuildable {
    public let path: Path = .relativeToRoot("Scripts/FeatureSwiftLintRunScript.sh")
    public let name: String = "SwiftLintShell"
    
    public init() { }
}
