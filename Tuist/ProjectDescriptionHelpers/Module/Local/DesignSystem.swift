//
//  DesignSystem.swift
//  ProjectDescriptionHelpers
//
//  Created by gnksbm on 4/6/25.
//

public struct DesignSystem: FrameworkTarget {
    public let product: Product = .framework
    public let infoPlist: InfoPlist?
    public let dependencies: [TargetDependency]
    public let resources: ResourceFileElements? = ["Resources/**"]
    
    public init(@TargetComponentBuilder dependencies builder: () -> TargetComponentBuilder = { .init() }) {
        let builder = builder()
        self.dependencies = builder.buildTargetDependency()
        self.infoPlist = builder.buildInfoPlist()
    }
}
