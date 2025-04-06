//
//  XCFrameworkDependency.swift
//  EnvironmentPlugin
//
//  Created by gnksbm on 3/31/25.
//

/// .xcframework는 Frameworks/ 경로에 위치해야 합니다.
public protocol XCFrameworkDependency: TargetDependencyBuildable, TypeNameContains {
    var frameworkName: String { get }
}

public extension XCFrameworkDependency {
    func buildTargetDependency() -> [TargetDependency] {
        [.xcframework(path: .relativeToRoot("Frameworks/\(frameworkName).xcframework"))]
    }
}
