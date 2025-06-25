//
//  LocalDependency.swift
//  EnvironmentPlugin
//
//  Created by gnksbm on 4/6/25.
//

public protocol LocalDependency: TargetDependencyBuildable {
    var targetDependencyPath: Path { get }
}

public extension LocalDependency where Self: TargetBuildable {
    func buildTargetDependency() -> [TargetDependency] {
        [.project(target: name, path: targetDependencyPath)]
    }
}
