//
//  SplashViewController.swift
//  App
//
//  Created by gnksbm on 6/30/25.
//  Copyright © 2025 Pepsi-Club. All rights reserved.
//

import UIKit
import DesignSystem

import RxSwift
import RxCocoa

final class SplashViewController: UIViewController {
    private let viewModel: SplashViewModel
    
    private let disposeBag: DisposeBag = .init()
    
    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = DesignSystemAsset.changeBlue.color
        
        let output = viewModel.transform(
            input: .init(
                viewDidLoad: .just(())
            )
        )
        
        output.alert
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, alert in
                guard !alert.actions.isEmpty else { return }
                let alertController = UIAlertController(
                    title: alert.title,
                    message: alert.message,
                    preferredStyle: .alert
                )
                alert.actions.forEach { alertAction in
                    let alertAction = UIAlertAction(
                        title: alertAction.title,
                        style: .default
                    ) { _ in
                        alertAction.handler()
                    }
                    alertController.addAction(alertAction)
                }
                owner.present(alertController, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
