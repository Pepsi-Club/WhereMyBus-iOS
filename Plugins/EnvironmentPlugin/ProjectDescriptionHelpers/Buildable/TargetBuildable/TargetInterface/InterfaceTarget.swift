//
//  InterfaceTarget.swift
//  EnvironmentPlugin
//
//  Created by gnksbm on 4/6/25.
//

public protocol InterfaceTarget: BundleIDSuffixTarget, LocalDependency { }

extension InterfaceTarget {
    var product: Product { .framework }
    var settings: Settings { .frameworkDebug }
}
