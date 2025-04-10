//
//  Domain.swift
//  ProjectDescriptionHelpers
//
//  Created by gnksbm on 4/6/25.
//

public struct Domain: FrameworkTarget {
    public let product: Product = .framework
    public let dependencies: [TargetDependency]
    
    public init(@TargetComponentBuilder dependencies builder: () -> TargetComponentBuilder = { .init() }) {
        self.dependencies = builder().buildTargetDependency()
    }
}
