//
//  Dependency+Feature.swift
//  DependencyPlugin
//
//  Created by gnksbm on 2023/11/23.
//

import ProjectDescription

public extension Array<TargetDependency> {
    enum Presentation: String, CaseIterable {
        case home, alarm, settings, busStop
        
        public var dependency: TargetDependency {
            var name = rawValue.map { $0 }
            name.removeFirst()
            name.insert(Character(rawValue.first!.uppercased()), at: 0)
            return presentationModule(name: "\(String(name))Feature")
        }
        
        private func presentationModule(name: String) -> TargetDependency {
            .project(
                target: "\(name)",
                path: .relativeToRoot("Projects/Feature/\(name)")
            )
        }
    }
}
