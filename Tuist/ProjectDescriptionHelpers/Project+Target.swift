//
//  Scripts.swift
//  ProjectDescriptionHelpers
//
//  Created by gnksbm on 2023/11/19.
//

import ProjectDescription

public enum ModuleType {
    case app, dynamicFramework, staticFramework, presentation
    
    var product: Product {
        switch self {
        case .app:
            return .app
        case .dynamicFramework:
            return .framework
        case .staticFramework, .presentation:
            return .staticFramework
        }
    }
}
