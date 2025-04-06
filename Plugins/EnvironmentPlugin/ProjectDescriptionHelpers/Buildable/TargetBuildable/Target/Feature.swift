//
//  Feature.swift
//  EnvironmentPlugin
//
//  Created by gnksbm on 4/6/25.
//

public struct Feature: ImplementTarget {
    public let name: String
    public let hasResource: Bool
    public let dependencies: [TargetDependency]
    
    public let product: Product = .staticFramework
    public let infoPlist: InfoPlist = .frameworkInfoPlist
    public let settings: Settings = .frameworkDebug
    public var scripts: [TargetScript] = [.featureSwiftLint]
    
    public var resources: ResourceFileElements? { hasResource ? ["Resources/**"] : nil }
    public var targetDependencyPath: Path {
        .relativeToRoot("Projects/Feature/\(name)")
    }
    
    public init(
        name: String,
        hasResource: Bool = false,
        @TargetDependencyBuilder dependencies builder: () -> TargetDependencyBuilder = { .init() }
    ) {
        self.name = name
        self.hasResource = hasResource
        self.dependencies = builder().buildTargetDependency()
    }
}
