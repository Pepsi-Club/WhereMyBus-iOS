//
//  LottieView +.swift
//  DesignSystem
//
//  Created by 유하은 on 5/1/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    var lottieFile: String
    var loopMode: LottieLoopMode = .loop
    var animationView = LottieAnimationView()
  
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView()
        
        animationView.animation = LottieAnimation.named(lottieFile)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.play()
        animationView.backgroundBehavior = .pauseAndRestore

        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        return view
    }
    
    func updateUIView(
        _ uiView: UIView,
        context: UIViewRepresentableContext<LottieView>
    ) {
        animationView.play()
    }
}
