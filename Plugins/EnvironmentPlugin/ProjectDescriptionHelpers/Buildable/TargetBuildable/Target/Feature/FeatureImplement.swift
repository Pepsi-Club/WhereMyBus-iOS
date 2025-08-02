//
//  FeatureImplement.swift
//  EnvironmentPlugin
//
//  Created by gnksbm on 7/12/25.
//

// TODO: Featuer 객체가 필요하지 않을 때 Feature로 네이밍 변경될 예정
public struct FeatureImplement: ImplementTarget {
    public let name: String
    public let hasResource: Bool
    public let dependencies: [TargetDependency]
    
    public let product: Product = .staticFramework
    public let infoPlist: InfoPlist?
    public let settings: Settings = .frameworkDebug
    public let scripts: [TargetScript]
    public var sources: SourceFilesList? { ["Implement/Sources/**"] }
    public var resources: ResourceFileElements? { hasResource ? ["Implement/Resources/**"] : nil }
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
