//
//  SearchStationBtn.swift
//  DesignSystem
//
//  Created by gnksbm on 1/23/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

public final class SearchStationBtn: UIButton {
    private var config = UIButton.Configuration.plain()
    private var titleContainer = AttributeContainer()
    
    public init(
        title: String? = nil,
        image: UIImage? = nil
    ) {
        super.init(frame: .zero)
        let attributedTitle = makeAttributedTitle(title: title)
        var config = makeConfiguration(
            attributedTitle: attributedTitle,
            image: image
        )
        configuration = config
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let titleWidth = titleLabel?.bounds.width,
              let imgWidth = imageView?.bounds.width
        else { return }
        let space = rect.width * 0.1
        let padding = rect.width - titleWidth - imgWidth - space
        configuration?.imagePadding = padding
    }
    
    private func makeConfiguration(
        attributedTitle: AttributedString?,
        image: UIImage?
    ) -> UIButton.Configuration {
        var config = UIButton.Configuration.plain()
        config.background.backgroundColor = DesignSystemAsset.gray2.color
        config.baseForegroundColor = DesignSystemAsset.mainColor.color
        config.cornerStyle = .large
        config.contentInsets = .init(
            top: 12,
            leading: 0,
            bottom: 12,
            trailing: 0
        )
        // MARK: Title
        config.attributedTitle = attributedTitle
        // MARK: Imgae
        config.image = image
        config.imagePadding = 5
        config.imagePlacement = .trailing
        config.preferredSymbolConfigurationForImage = makeImgConfig()
        return config
    }
    
    private func makeAttributedTitle(title: String?) -> AttributedString? {
        var attributedString: AttributedString?
        var titleContainer = AttributeContainer()
        titleContainer.foregroundColor = .gray
        titleContainer.font = .systemFont(
            ofSize: 14
        )
        if let title {
            attributedString = AttributedString(
                title,
                attributes: titleContainer
            )
        }
        return attributedString
    }
    
    private func makeImgConfig() -> UIImage.SymbolConfiguration {
        UIImage.SymbolConfiguration(
            font: .systemFont(ofSize: 14)
        )
    }
}
