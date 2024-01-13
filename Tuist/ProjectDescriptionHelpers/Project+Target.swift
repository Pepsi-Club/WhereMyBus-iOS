//
//  Scripts.swift
//  ProjectDescriptionHelpers
//
//  Created by gnksbm on 2023/11/19.
//

import ProjectDescription

public enum ModuleType {
    case app, framework, feature
    
    var product: Product {
        switch self {
        case .app:
            return .app
        case .framework:
            return .framework
        case .feature:
            return .app
        }
    }
}
