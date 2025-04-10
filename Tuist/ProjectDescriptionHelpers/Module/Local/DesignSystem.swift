//
//  DesignSystem.swift
//  ProjectDescriptionHelpers
//
//  Created by gnksbm on 4/6/25.
//

public struct DesignSystem: FrameworkTarget {
    public let product: Product = .framework
    public let dependencies: [TargetDependency]
    public let resources: ResourceFileElements? = ["Resources/**"]
    
    public init(@TargetDependencyBuilder dependencies builder: () -> TargetDependencyBuilder = { .init() }) {
        self.dependencies = builder().buildTargetDependency()
    }
}
