//
//  ImplementTarget.swift
//  EnvironmentPlugin
//
//  Created by gnksbm on 3/31/25.
//

public protocol ImplementTarget: BundleIDSuffixTarget, LocalDependency { }

public extension ImplementTarget {
    var sources: SourceFilesList? { ["Sources/**"] }
    var settings: Settings { .frameworkDebug }
}
