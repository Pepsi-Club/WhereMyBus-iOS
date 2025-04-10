//
//  TargetBuilder.swift
//  EnvironmentPlugin
//
//  Created by gnksbm on 3/31/25.
//

@resultBuilder
public struct TargetBuilder {
    let dependencyBuildable: [TargetDependencyBuildable]
    let targetBuildable: [TargetBuildable]
    
    init(
        dependencyBuildable: [TargetDependencyBuildable] = [],
        targetBuildable: [TargetBuildable] = []
    ) {
        self.dependencyBuildable = dependencyBuildable
        self.targetBuildable = targetBuildable
    }
}

// MARK: TargetBuilder
extension TargetBuilder {
    public static func buildBlock() -> TargetBuilder {
        .init()
    }
    
    public static func buildExpression(_ expression: TargetBuilder...) -> TargetBuilder {
        .init(
            dependencyBuildable: expression.flatMap { $0.dependencyBuildable },
            targetBuildable: expression.flatMap { $0.targetBuildable }
        )
    }
    
    public static func buildPartialBlock(first: TargetBuilder) -> TargetBuilder {
        first
    }
    
    public static func buildPartialBlock(accumulated: TargetBuilder, next: TargetBuilder) -> TargetBuilder {
        .init(
            dependencyBuildable: accumulated.dependencyBuildable + next.dependencyBuildable,
            targetBuildable: accumulated.targetBuildable + next.targetBuildable
        )
    }
}

// MARK: TargetBuildable
public extension TargetBuilder {
    static func buildExpression(_ expression: TargetBuildable) -> TargetBuilder {
        .init(targetBuildable: [expression])
    }
    
    static func buildEither(first component: [any TargetBuildable]) -> TargetBuilder {
        .init(targetBuildable: component)
    }
    
    static func buildEither(second component: [any TargetBuildable]) -> TargetBuilder {
        .init(targetBuildable: component)
    }
}

