//
//  ProjectComponentBuilder.swift
//  EnvironmentPlugin
//
//  Created by gnksbm on 4/6/25.
//

@resultBuilder
public struct ProjectComponentBuilder {
    let targets: [Target]
    let schemes: [Scheme]
    
    init(targets: [Target] = [], schemes: [Scheme] = []) {
        self.targets = targets
        self.schemes = schemes
    }
    
    public static func buildBlock() -> ProjectComponentBuilder {
        .init()
    }
    
    public static func buildExpression(_ expression: ProjectComponentBuilder) -> ProjectComponentBuilder {
        .init(targets: expression.targets, schemes: expression.schemes)
    }
    
    public static func buildPartialBlock(first: ProjectComponentBuilder) -> ProjectComponentBuilder {
        .init(targets: first.targets, schemes: first.schemes)
    }
    
    public static func buildPartialBlock(accumulated: ProjectComponentBuilder, next: ProjectComponentBuilder) -> ProjectComponentBuilder {
        .init(
            targets: accumulated.targets + next.targets,
            schemes: accumulated.schemes + next.schemes
        )
    }
}

extension ProjectComponentBuilder {
    public static func buildExpression(_ expression: TargetBuilder) -> ProjectComponentBuilder {
        .init(targets: expression.targetBuildable.map { $0.buildTarget() })
    }
}

extension ProjectComponentBuilder {
    public static func buildExpression(_ expression: TargetBuildable) -> ProjectComponentBuilder {
        .init(targets: [expression.buildTarget()])
    }
    
    public static func buildExpression(_ expression: TargetBuildable...) -> ProjectComponentBuilder {
        .init(targets: expression.map { $0.buildTarget() })
    }
    
    public static func buildExpression(_ expression: [TargetBuildable]) -> ProjectComponentBuilder {
        .init(targets: expression.map { $0.buildTarget() })
    }
}

extension ProjectComponentBuilder {
    public static func buildExpression(_ expression: SchemeBuildable) -> ProjectComponentBuilder {
        .init(schemes: [expression.buildScheme()])
    }
    
    public static func buildExpression(_ expression: SchemeBuildable...) -> ProjectComponentBuilder {
        .init(schemes: expression.map { $0.buildScheme() })
    }
    
    public static func buildExpression(_ expression: [SchemeBuildable]) -> ProjectComponentBuilder {
        .init(schemes: expression.map { $0.buildScheme() })
    }
}

public extension Project {
    init(
        name: String,
        packages: [Package] = [],
        options: Options = .options(),
        @ProjectComponentBuilder components builder: () -> ProjectComponentBuilder
    ) {
        let builder = builder()
        self.init(
            name: name,
            organizationName: .organizationName,
            options: options,
            packages: packages,
            targets: builder.targets,
            schemes: builder.schemes
        )
    }
}
