//
//  SPMDependency.swift
//  EnvironmentPlugin
//
//  Created by gnksbm on 3/31/25.
//

public protocol SPMDependency: TargetDependencyBuildable, TypeNameContains {
    var targetName: String { get }
}

public extension SPMDependency {
    func buildTargetDependency() -> [TargetDependency] {
        [.external(name: targetName)]
    }
}
