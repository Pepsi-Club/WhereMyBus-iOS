//
//  FirebaseInterface.swift
//  ProjectDescriptionHelpers
//
//  Created by gnksbm on 4/6/25.
//

public struct FirebaseInterface: FrameworkTarget {
    public let product: Product = .framework
    
    public let dependencies: [TargetDependency]
    
    public init(@TargetDependencyBuilder dependencies builder: () -> TargetDependencyBuilder = { .init() }) {
        self.dependencies = builder().buildTargetDependency()
    }
}

public struct FirebaseModule: FrameworkTarget {
    public let product: Product = .staticFramework
    
    public let dependencies: [TargetDependency]
    
    public init(@TargetDependencyBuilder dependencies builder: () -> TargetDependencyBuilder = { .init() }) {
        self.dependencies = builder().buildTargetDependency()
    }
}
