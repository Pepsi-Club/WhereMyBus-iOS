//
//  InfoPlistBuildable.swift
//  EnvironmentPlugin
//
//  Created by gnksbm on 4/11/25.
//

import ProjectDescription

public protocol InfoPlistBuildable {
    var dictionary: [String: Plist.Value] { get }
}

public extension InfoPlistBuildable {
    func buildInfoPlist() -> InfoPlist {
        .dictionary(dictionary)
    }
}

extension Array: InfoPlistBuildable where Element == any InfoPlistBuildable {
    public var dictionary: [String : Plist.Value] {
        reduce([String : Plist.Value]()) { partialResult, next in
            partialResult.merging(next.dictionary) { _, new in new }
        }
    }
}
