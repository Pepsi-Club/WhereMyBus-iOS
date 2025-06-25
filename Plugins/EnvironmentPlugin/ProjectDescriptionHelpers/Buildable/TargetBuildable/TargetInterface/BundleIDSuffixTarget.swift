//
//  BundleIDSuffixTarget.swift
//  EnvironmentPlugin
//
//  Created by gnksbm on 4/6/25.
//

public protocol BundleIDSuffixTarget: TargetBuildable { }

public extension BundleIDSuffixTarget {
    var bundleId: String { [.bundleID, name].joined(separator: ".") }
}
