//
//  SearchTextFieldView.swift
//  SearchFeature
//
//  Created by 유하은 on 2024/02/07.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import DesignSystem

public final class SearchTextFieldView: UITextField {
    private var titleContainer = AttributeContainer()

    public init(
        placeholder: String? = nil
    ) {
        super.init(frame: .zero)
        configureUI()
        setPlaceholder(placeholder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        self.backgroundColor = DesignSystemAsset.gray3.color
        self.font =
        DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(size: 15)
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        self.contentVerticalAlignment = .center
        self.leftViewMode = .always
    }
    
    //TODO: 꼭,, 고쳐야 됨~
    private func setPlaceholder(_ placeholder: String?) {
    self.placeholder = "    버스 정류장을 검색하세요                                                 "
    }
}
