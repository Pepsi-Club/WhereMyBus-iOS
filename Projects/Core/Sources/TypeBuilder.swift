//
//  TypeBuilder.swift
//  Core
//
//  Created by gnksbm on 7/6/25.
//  Copyright © 2025 Pepsi-Club. All rights reserved.
//

import Foundation

@resultBuilder
public enum TypeBuilder<T> {
    public static func buildBlock(_ components: T...) -> [T] {
        components
    }
}
