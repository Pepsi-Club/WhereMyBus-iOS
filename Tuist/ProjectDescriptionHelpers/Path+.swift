//
//  Path+.swift
//  ProjectDescriptionHelpers
//
//  Created by gnksbm on 3/30/25.
//

import ProjectDescription

extension Path  {
    static func relativeToFrameworks(_ name: String) -> Path {
        .relativeToRoot("Frameworks/\(name).xcframework")
    }
    
    static func relativeToProjects(_ name: String) -> Path {
        .relativeToRoot("Projects/\(name)")
    }
    
    static func relativeToFeature(_ name: String) -> Path {
        .relativeToRoot("Projects/Features/\(name)")
    }
}
