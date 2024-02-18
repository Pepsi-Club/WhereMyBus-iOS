//
//  TermsPrivacyViewController.swift
//  SettingsFeature
//
//  Created by Jisoo HAM on 2/15/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import WebKit

import RxSwift

public final class TermsPrivacyViewController
: UIViewController, WKNavigationDelegate {
    private let viewModel: TermsPrivacyViewModel
    
    private let disposeBag = DisposeBag()
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.frame = .zero
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }()
    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
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
        
        view.backgroundColor = .systemBackground
        
        webView.navigationDelegate = self
        
        configureUI()
        bind()
    }
    
    private func bind() {
        let input = TermsPrivacyViewModel.Input(
            viewWillAppearEvent: rx
                .methodInvoked(#selector(UIViewController.viewWillAppear))
                .map { _ in }
        )
        
        let output = viewModel.transform(input: input)
        
        output.termsOfPrivacyString
            .bind { [weak self] str in
                self?.updateUI(urlString: str)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        view.addSubview(webView)
        
        view.insertSubview(indicator, aboveSubview: webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            webView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            webView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            webView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            ),
            indicator.centerXAnchor.constraint(
                equalTo: webView.centerXAnchor
            ),
            indicator.centerYAnchor.constraint(
                equalTo: webView.centerYAnchor
            )
        ])
    }
    
    private func updateUI(urlString: String) {
        guard let url = URL(string: urlString) ?? URL(string: "") 
        else { return }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
}

extension TermsPrivacyViewController {
    public func webView(
        _ webView: WKWebView,
        didCommit navigation: WKNavigation!
    ) {
        indicator.startAnimating()
    }
    
    public func webView(
        _ webView: WKWebView,
        didFinish navigation: WKNavigation!
    ) {
        indicator.stopAnimating()
    }
}
