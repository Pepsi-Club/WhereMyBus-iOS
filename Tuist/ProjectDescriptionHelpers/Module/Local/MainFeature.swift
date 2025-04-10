//
//  MainFeature.swift
//  ProjectDescriptionHelpers
//
//  Created by gnksbm on 4/6/25.
//

public struct MainFeature: FrameworkTarget {
    public let product: Product = .framework
    public let dependencies: [TargetDependency]
    
    public init(@TargetDependencyBuilder dependencies builder: () -> TargetDependencyBuilder = { .init() }) {
        self.dependencies = builder().buildTargetDependency()
    }
}
