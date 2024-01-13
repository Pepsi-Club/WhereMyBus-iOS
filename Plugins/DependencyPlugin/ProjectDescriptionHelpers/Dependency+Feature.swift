//
//  Dependency+Feature.swift
//  DependencyPlugin
//
//  Created by gnksbm on 2023/11/23.
//

import ProjectDescription

public extension Array<TargetDependency> {
    enum Feature: String, CaseIterable {
        case home, map, my
        
        public var dependency: TargetDependency {
            var name = rawValue.map { $0 }
            name.removeFirst()
            name.insert(Character(rawValue.first!.uppercased()), at: 0)
            return featureModule(name: String(name))
        }
        
        private func featureModule(name: String) -> TargetDependency {
            .project(
                target: "\(name)Feature",
                path: .relativeToRoot("Projects/Feature/\(name)Feature")
            )
        }
    }
}
