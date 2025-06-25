//
//  AppExtensionTarget.swift
//  EnvironmentPlugin
//
//  Created by gnksbm on 3/31/25.
//

public protocol AppExtensionTarget: BundleIDSuffixTarget { }

public extension AppExtensionTarget {
    var product: Product { .appExtension }
}
