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

extension InfoPlistBuildable {
    func buildInfoPlist() -> InfoPlist {
        .dictionary(dictionary)
    }
}

extension Array where Element == any InfoPlistBuildable {
    func buildInfoPlist() -> InfoPlist {
        .dictionary(
            reduce([String: Plist.Value]()) { partialResult, next in
                partialResult.merging(next.dictionary) { _, new in new }
            }
        )
    }
}
