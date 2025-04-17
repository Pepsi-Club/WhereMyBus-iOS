//
//  UnitTests.swift
//  EnvironmentPlugin
//
//  Created by gnksbm on 4/6/25.
//

public struct UnitTests: TestsTarget {
    public let name: String
    public let infoPlist: InfoPlist?
    public let dependencies: [TargetDependency]
    public let product: Product = .unitTests
    
    public var bundleId: String {
        "\(name).Tests"
    }
    
    public init(
        name: String,
        @TargetComponentBuilder dependencies builder: () -> TargetComponentBuilder
    ) {
        let builder = builder()
        self.name = name
        self.dependencies = builder.buildTargetDependency()
        self.infoPlist = builder.buildInfoPlist()
    }
}
