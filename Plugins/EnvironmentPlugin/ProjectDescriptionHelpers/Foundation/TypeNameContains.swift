//
//  TypeNameContains.swift
//  EnvironmentPlugin
//
//  Created by gnksbm on 3/31/25.
//

import Foundation

public protocol TypeNameContains { }

public extension TypeNameContains {
    var typeName: String { String(describing: type(of: self)) }
}

public extension TypeNameContains where Self: SPMDependency {
    var targetName: String { typeName }
}

public extension TypeNameContains where Self: XCFrameworkDependency {
    var frameworkName: String { typeName }
}

public extension TypeNameContains where Self: TargetBuildable {
    var name: String { typeName }
}
