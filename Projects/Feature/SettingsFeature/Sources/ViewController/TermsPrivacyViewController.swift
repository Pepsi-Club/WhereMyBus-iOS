//
//  TermsPrivacyViewController.swift
//  SettingsFeature
//
//  Created by Jisoo HAM on 2/15/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import RxSwift

public final class TermsPrivacyViewController: UIViewController {
    private let viewModel: TermsPrivacyViewModel
    
    private let disposeBag = DisposeBag()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .blue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(viewModel: TermsPrivacyViewModel) {
        self.viewModel = viewModel
    
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .cyan
        
        view.addSubview(label)
        bind()
    }
    
    private func bind() {
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        let output = viewModel.transform()
        
        configureUI(text: output.urlString)
    }
    
    private func configureUI(text: String) {
        label.text = text
    }
    
}
