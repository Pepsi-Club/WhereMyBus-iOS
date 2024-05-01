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
    static func setting() {
        let animationView = LottieAnimationView()
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
    }
}
