//
//  SerachBoxView.swift
//  SearchFeatureDemo
//
//  Created by 유하은 on 2024/02/04.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

final class SearchTextFieldBoxView: UIView {
    
    private var titleContainer = AttributeContainer()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    public init(
        title: String? = nil,
        placeholder: String? = nil
    ) {
        super.init(frame: .zero)
        configureUI()
        setTitle(title)
        setPlaceholder(placeholder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(titleLabel)
        addSubview(textField)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            textField.leadingAnchor.constraint(
                equalTo: titleLabel.trailingAnchor, constant: 5),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }
    
    private func setTitle(_ title: String?) {
        titleLabel.text = title
    }
    
    private func setPlaceholder(_ placeholder: String?) {
        textField.placeholder = placeholder
    }
    
    @objc private func handleTap() {
        textField.becomeFirstResponder()
    }
    
    public func getText() -> String? {
        return textField.text
    }
}
