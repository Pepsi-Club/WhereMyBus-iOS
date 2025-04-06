//
//  UnitTests.swift
//  EnvironmentPlugin
//
//  Created by gnksbm on 4/6/25.
//

public struct UnitTests: TestsTarget {
    public var name: String
    
    public let product: Product = .unitTests
    
    public var bundleId: String {
        "\(name).Tests"
    }
    
    public init(name: String) {
        self.name = name
    }
}
