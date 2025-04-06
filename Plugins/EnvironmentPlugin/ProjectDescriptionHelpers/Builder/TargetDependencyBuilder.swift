//
//  TargetDependencyBuilder.swift
//  EnvironmentPlugin
//
//  Created by gnksbm on 3/31/25.
//

@resultBuilder
public struct TargetDependencyBuilder {
    var dependencyBuildable: [TargetDependencyBuildable] = .init()
    
    public init() { }
    
    init(dependencyBuildable: [TargetDependencyBuildable]) {
        self.dependencyBuildable = dependencyBuildable
    }
}

// MARK: TargetDependencyBuilder
public extension TargetDependencyBuilder {
    static func buildBlock() -> TargetDependencyBuilder {
        .init()
    }
    
    static func buildExpression(_ expression: TargetDependencyBuilder...) -> TargetDependencyBuilder {
        .init(dependencyBuildable: expression.flatMap { $0.dependencyBuildable })
    }
    
    static func buildPartialBlock(first: TargetDependencyBuilder) -> TargetDependencyBuilder {
        first
    }
    
    static func buildPartialBlock(accumulated: TargetDependencyBuilder, next: TargetDependencyBuilder) -> TargetDependencyBuilder {
        .init(dependencyBuildable: accumulated.dependencyBuildable + next.dependencyBuildable)
    }
}

// MARK: TargetDependencyBuildable
public extension TargetDependencyBuilder {
    static func buildExpression(_ expression: TargetDependencyBuildable) -> TargetDependencyBuilder {
        .init(dependencyBuildable: [expression])
    }
}

extension TargetDependencyBuilder: TargetDependencyBuildable {
    public func buildTargetDependency() -> [TargetDependency] {
        dependencyBuildable.flatMap { $0.buildTargetDependency() }
    }
}
