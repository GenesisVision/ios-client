//
//  CoinAssetPortfolioTableViewCell.swift
//  genesisvision-ios
//
//  Created by Gregory on 27.04.2022.
//  Copyright © 2022 Genesis Vision. All rights reserved.
//

import UIKit

class CoinAssetTableViewCell: UITableViewCell {
    var cellContentView = UIStackView() {
        didSet {
            cellContentView.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ asset: CoinsAsset, filterProtocol: FilterChangedProtocol?, favoriteProtocol: FavoriteStateChangeProtocol?) {
        cellContentView = CoinAssetInvestingContentView.viewFromNib()
        addSubview(cellContentView)
        cellContentView.fillSuperview(padding: UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15))
        (cellContentView as? CoinAssetInvestingContentView)?.configure(asset, filterProtocol: filterProtocol, favoriteProtocol: favoriteProtocol)
    }
    
    func configure(_ asset: CoinsHistoryEvent, filterProtocol: FilterChangedProtocol?, favoriteProtocol: FavoriteStateChangeProtocol?) {
        cellContentView = CoinAssetInvestingHistoryContentView.viewFromNib()
        addSubview(cellContentView)
        cellContentView.fillSuperview(padding: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20))
        (cellContentView as? CoinAssetInvestingHistoryContentView)?.configure(asset, filterProtocol: filterProtocol, favoriteProtocol: favoriteProtocol)
    }
}
