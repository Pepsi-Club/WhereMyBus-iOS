//
//  FeatureInterface.swift
//  EnvironmentPlugin
//
//  Created by gnksbm on 7/12/25.
//

public struct FeatureInterface: BundleIDSuffixTarget, LocalDependency {
    public var projectName: String
    public let dependencies: [TargetDependency]
    public let infoPlist: InfoPlist?
    public let scripts: [TargetScript]
    
    public var name: String { projectName + "Interface" }
    public var product: Product { .framework }
    public var sources: SourceFilesList? { ["Interface/Sources/**"] }
    
    public init(
        name: String,
        @TargetComponentBuilder dependencies builder: () -> TargetComponentBuilder = { .init() }
    ) {
        let builder = builder()
        self.projectName = name
        self.dependencies = builder.buildTargetDependency()
        self.scripts = builder.buildTargetScript()
        self.infoPlist = builder.buildInfoPlist()
    }
    
    public var targetDependencyPath: Path {
        .relativeToRoot("Projects/Feature/\(projectName)")
    }
    
//    public func buildTargetDependency() -> [TargetDependency] {
//        [
//            .pro
//            .target(name: name, status: .optional, condition: nil)
//        ]
//    }
}
