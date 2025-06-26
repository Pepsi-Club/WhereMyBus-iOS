//
//  PreTargetScriptBuildable.swift
//  EnvironmentPlugin
//
//  Created by gnksbm on 4/11/25.
//

public protocol PreTargetScriptBuildable: TargetScriptBuildable {
    var path: Path { get }
    var arguments: [String] { get }
    var name: String { get }
    var inputPaths: [FileListGlob] { get }
    var inputFileListPaths: [Path] { get }
    var outputPaths: [Path] { get }
    var outputFileListPaths: [Path] { get }
    var basedOnDependencyAnalysis: Bool? { get }
    var runForInstallBuildsOnly: Bool { get }
    var shellPath: String { get }
    var dependencyFile: Path? { get }
}

public extension PreTargetScriptBuildable {
    var arguments: [String] { [] }
    var inputPaths: [FileListGlob] { [] }
    var inputFileListPaths: [Path] { [] }
    var outputPaths: [Path] { [] }
    var outputFileListPaths: [Path] { [] }
    var basedOnDependencyAnalysis: Bool? { false }
    var runForInstallBuildsOnly: Bool { false }
    var shellPath: String { "/bin/sh" }
    var dependencyFile: Path? { nil }
}

public extension PreTargetScriptBuildable {
    func buildTargetScript() -> [TargetScript] {
        [
            .pre(
                path: path,
                name: name,
                inputPaths: inputPaths,
                inputFileListPaths: inputFileListPaths,
                outputPaths: outputPaths,
                outputFileListPaths: outputFileListPaths,
                basedOnDependencyAnalysis: basedOnDependencyAnalysis,
                runForInstallBuildsOnly: runForInstallBuildsOnly,
                shellPath: shellPath,
                dependencyFile: dependencyFile
            )
        ]
    }
}
