//
//  TargetDependency+Module.swift
//  ProjectDescriptionHelpers
//
//  Created by gnksbm on 3/30/25.
//

import ProjectDescription

public extension TargetDependency {
    private static func module(name: String) -> TargetDependency {
        .project(target: name, path: .relativeToProjects(name))
    }
    
    static let App: TargetDependency = .module(name: "App")
    static let MainFeature: TargetDependency = .module(name: "MainFeature")
    static let FeatureDependency: TargetDependency = .module(name: "FeatureDependency")
    static let Core: TargetDependency = .module(name: "Core")
    static let Data: TargetDependency = .module(name: "Data")
    static let Domain: TargetDependency = .module(name: "Domain")
    static let NetworkService: TargetDependency = .module(name: "NetworkService")
    static let CoreDataService: TargetDependency = .module(name: "CoreDataService")
    static let DesignSystem: TargetDependency = .module(name: "DesignSystem")
    static let ThirdPartyLibs: TargetDependency = .module(name: "ThirdPartyLibs")
    static let FirebaseModule: TargetDependency = .module(name: "FirebaseModule")
    static let FirebaseInterface: TargetDependency = .module(name: "FirebaseInterface")
}
