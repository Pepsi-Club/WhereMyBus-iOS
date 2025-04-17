//
//  FeatureDependency.swift
//  ProjectDescriptionHelpers
//
//  Created by gnksbm on 4/6/25.
//

public struct FeatureDependency: FrameworkTarget {
    public let product: Product = .framework
    public let infoPlist: InfoPlist?
    public let dependencies: [TargetDependency]
    
    public init(@TargetComponentBuilder dependencies builder: () -> TargetComponentBuilder = { .init() }) {
        let builder = builder()
        self.dependencies = builder.buildTargetDependency()
        self.infoPlist = builder.buildInfoPlist()
    }
}
