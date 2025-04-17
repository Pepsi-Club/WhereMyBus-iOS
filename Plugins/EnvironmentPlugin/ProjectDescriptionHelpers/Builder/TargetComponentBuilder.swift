//
//  TargetComponentBuilder.swift
//  EnvironmentPlugin
//
//  Created by gnksbm on 3/31/25.
//

@resultBuilder
public struct TargetComponentBuilder {
    let dependencyBuildables: [TargetDependencyBuildable]
    let targetScriptBuildables: [TargetScriptBuildable]
    let infoPlistBuildables: [InfoPlistBuildable]
    
    public init(
        dependencyBuildables: [TargetDependencyBuildable] = [],
        targetScriptBuildables: [TargetScriptBuildable] = [],
        infoPlistBuildables: [InfoPlistBuildable] = []
    ) {
        self.dependencyBuildables = dependencyBuildables
        self.targetScriptBuildables = targetScriptBuildables
        self.infoPlistBuildables = infoPlistBuildables
    }
}

// MARK: TargetComponentBuilder
public extension TargetComponentBuilder {
    static func buildBlock() -> TargetComponentBuilder {
        .init()
    }
    
    static func buildExpression(_ expression: TargetComponentBuilder...) -> TargetComponentBuilder {
        .init(dependencyBuildables: expression.flatMap { $0.dependencyBuildables })
    }
    
    static func buildPartialBlock(first: TargetComponentBuilder) -> TargetComponentBuilder {
        first
    }
    
    static func buildPartialBlock(accumulated: TargetComponentBuilder, next: TargetComponentBuilder) -> TargetComponentBuilder {
        .init(dependencyBuildables: accumulated.dependencyBuildables + next.dependencyBuildables)
    }
}

// MARK: TargetDependencyBuildable
public extension TargetComponentBuilder {
    static func buildExpression(_ expression: TargetDependencyBuildable) -> TargetComponentBuilder {
        .init(dependencyBuildables: [expression])
    }
}

extension TargetComponentBuilder: TargetDependencyBuildable {
    public func buildTargetDependency() -> [TargetDependency] {
        dependencyBuildables.flatMap { $0.buildTargetDependency() }
    }
}

// MARK: TargetScriptBuildable
public extension TargetComponentBuilder {
    static func buildExpression(_ expression: TargetScriptBuildable) -> TargetComponentBuilder {
        .init(targetScriptBuildables: [expression])
    }
}

extension TargetComponentBuilder: TargetScriptBuildable {
    public func buildTargetScript() -> [TargetScript] {
        targetScriptBuildables.flatMap { $0.buildTargetScript() }
    }
}

// MARK: InfoPlistBuildable
public extension TargetComponentBuilder {
    static func buildExpression(_ expression: InfoPlistBuildable) -> TargetComponentBuilder {
        .init(infoPlistBuildables: [expression])
    }
}

extension TargetComponentBuilder: InfoPlistBuildable {
    public var dictionary: [String : ProjectDescription.Plist.Value] {
        [:]
    }
    
    public func buildInfoPlist() -> InfoPlist {
        buildInfoPlist()
    }
}
