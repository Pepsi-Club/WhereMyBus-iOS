//
//  TypeBuilder.swift
//  EnvironmentPlugin
//
//  Created by gnksbm on 4/11/25.
//

import Foundation

@resultBuilder
struct TypeBuilder<T> {
    static func buildBlock(_ components: T...) -> [T] {
        components
    }
}
