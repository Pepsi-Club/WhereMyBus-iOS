//
//  Depondency+ThirdPartyXCFramework.swift
//  DependencyPlugin
//
//  Created by gnksbm on 3/30/24.
//

import Foundation
import ProjectDescription

public extension Array<TargetDependency> {
    static let thirdPartyXCFramework = ThirdPartyXCFramework.allCases
        .map {
            $0.toXcFramework()
        }
    
    enum ThirdPartyXCFramework: String, CaseIterable {
        case nMapsGeometry = "NMapsGeometry"
        case nMapsMap = "NMapsMap"
        
        var additionalPath: String {
            switch self {
            case .nMapsMap, .nMapsGeometry:
                return "NMapsMap/"
            }
        }
        
        public func toXcFramework() -> Element {
            .xcframework(
                path: .relativeToRoot(
                    "Frameworks/\(additionalPath)\(rawValue).xcframework"
                )
            )
        }
    }
}
