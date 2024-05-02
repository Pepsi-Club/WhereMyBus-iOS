//
//  LottieView.swift
//  DesignSystem
//
//  Created by 유하은 on 5/1/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit
import Lottie

extension LottieAnimationView {
    public func setting(contentMode: UIView.ContentMode = .scaleAspectFit) {
        self.contentMode = contentMode
        self.loopMode = .loop
        self.backgroundBehavior = .pause
        self.animationSpeed = 0.5
        self.play()
    }
}
