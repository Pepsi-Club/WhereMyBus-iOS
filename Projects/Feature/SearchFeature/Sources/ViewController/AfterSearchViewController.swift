//
//  AfterSearchViewController.swift
//  SearchFeature
//
//  Created by 유하은 on 2024/02/13.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import Core
import DesignSystem

import RxSwift
import RxCocoa
import RxDataSources

public final class AfterSearchViewController: UIViewController {
    private let viewModel: SearchViewModel
    
    private let searchTextFieldView = SearchTextFieldView()
    
    private let backBtn: UIButton = {
        let btn = UIButton()
        let starImage = UIImage(systemName: "chevron.backward")
        btn.setImage(starImage, for: .normal)
        btn.tintColor = .black
        return btn
    }()
    
    private let recentSearchlabel: UILabel = {
        let label = UILabel()
        label.font =
        DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(size: 15)
        label.textColor = DesignSystemAsset.gray4.color
        label.text = "서울"
        
        return label
    }()
    
    private let magniImage: UIImageView = {
        let symbolName = "magnifyingglass"

        var configuration = UIImage.SymbolConfiguration(pointSize: 8,
                                                        weight: .light)
        configuration = configuration.applying(UIImage.SymbolConfiguration(
                            font: UIFont.systemFont(ofSize: 20, weight: .light),
                            scale: .default))

        let migImage = UIImage(
            systemName: symbolName,
            withConfiguration: configuration)?.withTintColor(.black)

        let migImageView = UIImageView(image: migImage)
        migImageView.tintColor = DesignSystemAsset.gray4.color

        return migImageView
    }()

    private let coloredRectangleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 230/255,
                                       green: 237/255,
                                       blue: 255/255,
                                       alpha: 1.0)
        return view
    }()
    
    private let textFieldStack: UIStackView = {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.alignment = .center
        
            return stack
        }()
    
    private let headerStack: UIStackView = {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.alignment = .center
            stack.spacing = 100
            stack.distribution = .fill
            
        return stack
        }()
    
    private let magniStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 100
        
        return stack
    }()
    
    private let disposeBag = DisposeBag()
    private let searchEnterEvent = PublishSubject<String>()
    public init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        [searchTextFieldView, backBtn, textFieldStack, recentSearchlabel,
          coloredRectangleView,
         headerStack, magniStack, magniImage]
            .forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [backBtn, searchTextFieldView]
            .forEach { components in
                textFieldStack.addArrangedSubview(components)
            }
        
        NSLayoutConstraint.activate([
        backBtn.widthAnchor.constraint(equalToConstant: 20),
        
        magniImage.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: -5
            ),
        
        magniImage.widthAnchor.constraint(
                equalToConstant: 20
            ),
        
        magniImage.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -20
            ),
            
        searchTextFieldView.heightAnchor.constraint(
                equalToConstant: 39),
           
        textFieldStack.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: -14
            ),
        textFieldStack.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 10
            ),
        
        textFieldStack.trailingAnchor.constraint(
            equalTo: magniImage.trailingAnchor,
            constant: 10
            ),
        
        headerStack.topAnchor.constraint(
                equalTo: textFieldStack.bottomAnchor, constant: 15),
        headerStack.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 15),
        headerStack.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -15),
           ])
       }
}

extension SearchViewController: UITextFieldDelegate {

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
}
