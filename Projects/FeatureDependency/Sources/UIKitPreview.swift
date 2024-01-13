//
//  UIKitPreview.swift
//  FeatureDependency
//
//  Created by gnksbm on 2023/11/25.
//  Copyright © 2023 gnksbm All rights reserved.
//

import SwiftUI
#if DEBUG
public struct UIKitPreview: UIViewControllerRepresentable {
    public let viewController: UIViewController
    
    public init(_ viewController: UIViewController) {
        self.viewController = viewController
    }
    
    public func makeUIViewController(
        context: Context
    ) -> some UINavigationController {
        return UINavigationController(rootViewController: viewController)
    }
    
    public func updateUIViewController(
        _ uiViewController: UIViewControllerType,
        context: Context
    ) { }
}
#endif
