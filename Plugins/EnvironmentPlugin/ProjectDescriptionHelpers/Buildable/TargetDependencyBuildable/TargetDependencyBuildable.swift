//
//  TargetDependencyBuildable.swift
//  EnvironmentPlugin
//
//  Created by gnksbm on 3/31/25.
//

public protocol TargetDependencyBuildable {
    func buildTargetDependency() -> [TargetDependency]
}

extension TargetDependency: TargetDependencyBuildable {
    public func buildTargetDependency() -> [TargetDependency] {
        [self]
    }
}
