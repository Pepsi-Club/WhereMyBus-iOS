//
//  TargetDependency+Feature.swift
//  ProjectDescriptionHelpers
//
//  Created by gnksbm on 3/30/25.
//

import ProjectDescription

public extension TargetDependency {
    private static func feature(name: String) -> TargetDependency {
        .project(target: "\(name)Feature", path: .relativeToFeature(name))
    }
    
    static let Home: TargetDependency = .feature(name: "Home")
    static let Alarm: TargetDependency = .feature(name: "Alarm")
    static let Settings: TargetDependency = .feature(name: "Settings")
    static let BusStop: TargetDependency = .feature(name: "BusStop")
    static let Search: TargetDependency = .feature(name: "Search")
    static let NearMap: TargetDependency = .feature(name: "NearMap")
}
