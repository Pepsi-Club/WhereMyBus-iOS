//
//  Feature.swift
//  ProjectDescriptionHelpers
//
//  Created by gnksbm on 2023/11/20.
//

import ProjectDescription

private let nameAttribute = Template.Attribute.required("name")

private let template = Template(
    description: "Framework 모듈 템플릿",
    attributes: [
        nameAttribute,
    ],
    items: [
        // MARK: Project.swift
        .file(path: projectPath(with: "Project.swift"), templatePath: "project.stencil"),
        // MARK: EmptyFile
        .string(path: projectPath(with: "Sources/Temp.swift"), contents: "// "),
        // MARK: UnitTests
        .file(path: projectPath(with: "Tests/\(nameAttribute)FeatureTests.swift"), templatePath: "tests.stencil"),
    ]
)

private func projectPath(with name: String) -> String {
    "Projects/\(nameAttribute)/\(name)"
}
