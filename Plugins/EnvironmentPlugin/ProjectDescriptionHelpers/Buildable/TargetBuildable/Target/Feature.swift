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
    public let infoPlist: InfoPlist?
    public let settings: Settings = .frameworkDebug
    public let scripts: [TargetScript]
    
    public var resources: ResourceFileElements? { hasResource ? ["Resources/**"] : nil }
    public var targetDependencyPath: Path {
        .relativeToRoot("Projects/Feature/\(name)")
    }
    
    public init(
        name: String,
        hasResource: Bool = false,
        @TargetComponentBuilder dependencies builder: () -> TargetComponentBuilder = { .init() }
    ) {
        let builder = builder()
        self.name = name
        self.hasResource = hasResource
        self.dependencies = builder.buildTargetDependency()
        self.scripts = builder.buildTargetScript()
        self.infoPlist = builder.buildInfoPlist()
    }
}
