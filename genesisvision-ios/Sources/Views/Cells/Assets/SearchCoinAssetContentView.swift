//
//  SearchCoinAssetContentView.swift
//  genesisvision-ios
//
//  Created by Gregory on 24.05.2022.
//  Copyright © 2022 Genesis Vision. All rights reserved.
//

import UIKit

class SearchCoinAssetContentView: UIStackView {
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var nameLabel: TitleLabel!
    @IBOutlet weak var symbolLabel: SubtitleLabel!
}

extension SearchCoinAssetContentView: ContentViewProtocol {
    func configure(_ asset: BasePlatformAsset) {
        if let name = asset.name {
            nameLabel.text = name
        }
        if let symbol = asset.asset {
            symbolLabel.text = symbol
        }
        if let fileName = asset.logoUrl, let fileUrl = getFileURL(fileName: fileName) {
            logoImage.kf.setImage(with: fileUrl, placeholder: UIImage.noDataPlaceholder)
        }
    }
}
