//
//  FeatureTesting.swift
//  EnvironmentPlugin
//
//  Created by gnksbm on 7/19/25.
//

import Foundation

public struct FeatureTesting: BundleIDSuffixTarget, LocalDependency {
    public var projectName: String
    public let dependencies: [TargetDependency]
    public let infoPlist: InfoPlist?
    public let scripts: [TargetScript]
    
    public var name: String { projectName + "Testing" }
    public var product: Product { .framework }
    public var sources: SourceFilesList? { ["Testing/Sources/**"] }
    public var targetDependencyPath: Path {
        .relativeToRoot("Projects/Feature/\(projectName)")
    }
    
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
}
