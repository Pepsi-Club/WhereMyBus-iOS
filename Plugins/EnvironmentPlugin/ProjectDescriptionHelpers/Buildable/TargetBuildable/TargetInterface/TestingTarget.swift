//
//  TestingTarget.swift
//  EnvironmentPlugin
//
//  Created by gnksbm on 4/6/25.
//

public protocol TestingTarget: TargetBuildable { }

public extension TestingTarget {
    var sources: SourceFilesList? { ["Testing/**"] }
}
