//
//  AssetTableViewCell.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Charts

protocol ContentViewProtocol {
    func configure(_ asset: FundDetailsListItem, filterProtocol: FilterChangedProtocol?, favoriteProtocol: FavoriteStateChangeProtocol?)
    func configure(_ asset: ProgramDetailsListItem, filterProtocol: FilterChangedProtocol?, favoriteProtocol: FavoriteStateChangeProtocol?)
    func configure(_ asset: FollowDetailsListItem, filterProtocol: FilterChangedProtocol?, favoriteProtocol: FavoriteStateChangeProtocol?)
    
    func configure(_ asset: FundInvestingDetailsList, filterProtocol: FilterChangedProtocol?, favoriteProtocol: FavoriteStateChangeProtocol?)
    func configure(_ asset: ProgramInvestingDetailsList, filterProtocol: FilterChangedProtocol?, favoriteProtocol: FavoriteStateChangeProtocol?)
    func configure(_ asset: CoinsAsset, filterProtocol: FilterChangedProtocol?, favoriteProtocol: FavoriteStateChangeProtocol?)
    func configure(_ asset: DashboardTradingAsset, filterProtocol: FilterChangedProtocol?)
    func configure(type: AssetType)
    func configure(programTrading asset: DashboardTradingAsset, filterProtocol: FilterChangedProtocol?)
    func configure(followTrading asset: DashboardTradingAsset, filterProtocol: FilterChangedProtocol?)
    func configure(fundTrading asset: DashboardTradingAsset, filterProtocol: FilterChangedProtocol?)
}

extension ContentViewProtocol {
    func configure(_ asset: FundDetailsListItem, filterProtocol: FilterChangedProtocol?, favoriteProtocol: FavoriteStateChangeProtocol?) {}
    func configure(_ asset: ProgramDetailsListItem, filterProtocol: FilterChangedProtocol?, favoriteProtocol: FavoriteStateChangeProtocol?) {}
    func configure(_ asset: FollowDetailsListItem, filterProtocol: FilterChangedProtocol?, favoriteProtocol: FavoriteStateChangeProtocol?) {}
    func configure(_ asset: FundInvestingDetailsList, filterProtocol: FilterChangedProtocol?, favoriteProtocol: FavoriteStateChangeProtocol?) {}
    func configure(_ asset: ProgramInvestingDetailsList, filterProtocol: FilterChangedProtocol?, favoriteProtocol: FavoriteStateChangeProtocol?) {}
    func configure(_ asset: CoinsAsset, filterProtocol: FilterChangedProtocol?, favoriteProtocol: FavoriteStateChangeProtocol?) {}
    func configure(type: AssetType){}
    func configure(_ asset: BasePlatformAsset) {}
    func configure(_ asset: DashboardTradingAsset, filterProtocol: FilterChangedProtocol?) {}
    func configure(programTrading asset: DashboardTradingAsset, filterProtocol: FilterChangedProtocol?) {}
    func configure(followTrading asset: DashboardTradingAsset, filterProtocol: FilterChangedProtocol?) {}
    func configure(fundTrading asset: DashboardTradingAsset, filterProtocol: FilterChangedProtocol?) {}
}

class RoundedBackgroundView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = UIColor.white.withAlphaComponent(0.02)
        roundCorners(with: 8)
    }
}
class FundAssetView: RoundedBackgroundView {
    @IBOutlet weak var assetLogoImageView: UIImageView! {
        didSet {
            assetLogoImageView.roundCorners()
        }
    }
    @IBOutlet weak var assetPercentLabel: TitleLabel!
}

class AssetTableViewCell: PlateTableViewCell {
    
    // MARK: - Views
    @IBOutlet weak var stackView: UIStackView!
    
    var cellContentView: ContentViewProtocol!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgColor = UIColor.Cell.bg
    }
    
    // MARK: - Public methods
    /// Fund
    /// - Parameters:
    ///   - asset: FundDetailsListItem
    ///   - filterProtocol: FilterChangedProtocol
    ///   - favoriteProtocol: FavoriteStateChangeProtocol
    func configure(_ asset: FundDetailsListItem, filterProtocol: FilterChangedProtocol?, favoriteProtocol: FavoriteStateChangeProtocol?) {
        stackView.removeAllArrangedSubviews()
        cellContentView = FundContentView.viewFromNib()
        if let cellContentView = cellContentView as? FundContentView {
            stackView.addArrangedSubview(cellContentView)
            cellContentView.configure(asset, filterProtocol: filterProtocol, favoriteProtocol: favoriteProtocol)
        }
    }
    
    /// Program
    /// - Parameters:
    ///   - asset: ProgramDetailsListItem
    ///   - filterProtocol: FilterChangedProtocol
    ///   - favoriteProtocol: FavoriteStateChangeProtocol
    func configure(_ asset: ProgramDetailsListItem, filterProtocol: FilterChangedProtocol?, favoriteProtocol: FavoriteStateChangeProtocol?) {
        stackView.removeAllArrangedSubviews()
        cellContentView = ProgramContentView.viewFromNib()
        if let cellContentView = cellContentView as? ProgramContentView {
            stackView.addArrangedSubview(cellContentView)
            cellContentView.configure(asset, filterProtocol: filterProtocol, favoriteProtocol: favoriteProtocol)
        }
    }
    
    /// Follow
    /// - Parameters:
    ///   - asset: FollowDetailsListItem
    ///   - filterProtocol: FilterChangedProtocol
    ///   - favoriteProtocol: FavoriteStateChangeProtocol
    func configure(_ asset: FollowDetailsListItem, filterProtocol: FilterChangedProtocol?, favoriteProtocol: FavoriteStateChangeProtocol?) {
        cellContentView = FollowContentView.viewFromNib()
        if let cellContentView = cellContentView as? FollowContentView {
            stackView.removeAllArrangedSubviews()
            stackView.addArrangedSubview(cellContentView)
            cellContentView.configure(asset, filterProtocol: filterProtocol, favoriteProtocol: favoriteProtocol)
        }
    }
    
    /// CoinsAsset
    /// - Parameters:
    ///   - asset: CoinsAsset
    ///   - filterProtocol: FilterChangedProtocol
    ///   - favoriteProtocol: FavoriteStateChangeProtocol
    func configure(_ asset: CoinsAsset, filterProtocol: FilterChangedProtocol?, favoriteProtocol: FavoriteStateChangeProtocol?) {
        stackView.removeAllArrangedSubviews()
        cellContentView = CoinAssetContentView.viewFromNib()
        if let cellContentView = cellContentView as? CoinAssetContentView {
            stackView.addArrangedSubview(cellContentView)
            cellContentView.configure(asset, filterProtocol: filterProtocol, favoriteProtocol: favoriteProtocol)
        }
    }
    
    /// FundInvesting
    /// - Parameters:
    ///   - asset: FundInvestingDetailsList
    ///   - filterProtocol: FilterChangedProtocol
    ///   - favoriteProtocol: FavoriteStateChangeProtocol
    func configure(_ asset: FundInvestingDetailsList, filterProtocol: FilterChangedProtocol?, favoriteProtocol: FavoriteStateChangeProtocol?) {
        stackView.removeAllArrangedSubviews()
        cellContentView = FundInvestingContentView.viewFromNib()
        if let cellContentView = cellContentView as? FundInvestingContentView {
            stackView.addArrangedSubview(cellContentView)
            cellContentView.configure(asset, filterProtocol: filterProtocol, favoriteProtocol: favoriteProtocol)
        }
    }
    
    /// ProgramInvesting
    /// - Parameters:
    ///   - asset: ProgramInvestingDetailsList
    ///   - filterProtocol: FilterChangedProtocol
    ///   - favoriteProtocol: FavoriteStateChangeProtocol
    func configure(_ asset: ProgramInvestingDetailsList, filterProtocol: FilterChangedProtocol?, favoriteProtocol: FavoriteStateChangeProtocol?) {
        stackView.removeAllArrangedSubviews()
        cellContentView = ProgramInvestingContentView.viewFromNib()
        if let cellContentView = cellContentView as? ProgramInvestingContentView {
            stackView.addArrangedSubview(cellContentView)
            cellContentView.configure(asset, filterProtocol: filterProtocol, favoriteProtocol: favoriteProtocol)
        }
    }
    
    
    /// DashboardTrading
    /// - Parameters:
    ///   - asset: DashboardTradingAsset
    ///   - delegate: FavoriteStateChangeProtocol
    func configure(_ asset: DashboardTradingAsset, filterProtocol: FilterChangedProtocol?) {
        stackView.removeAllArrangedSubviews()
        switch asset.assetType {
        case .program:
            cellContentView = ProgramTradingContentView.viewFromNib()
            if let cellContentView = cellContentView as? ProgramTradingContentView {
                stackView.addArrangedSubview(cellContentView)
                cellContentView.configure(programTrading: asset, filterProtocol: filterProtocol)
            }
        case .follow:
            cellContentView = FollowTradingContentView.viewFromNib()
            if let cellContentView = cellContentView as? FollowTradingContentView {
                stackView.addArrangedSubview(cellContentView)
                cellContentView.configure(followTrading: asset, filterProtocol: filterProtocol)
            }
        case .fund:
            cellContentView = FundTradingContentView.viewFromNib()
            if let cellContentView = cellContentView as? FundTradingContentView {
                stackView.addArrangedSubview(cellContentView)
                cellContentView.configure(fundTrading: asset, filterProtocol: filterProtocol)
            }
        default:
            cellContentView = PrivateTradingContentView.viewFromNib()
            if let cellContentView = cellContentView as? PrivateTradingContentView {
                stackView.addArrangedSubview(cellContentView)
                cellContentView.configure(asset, filterProtocol: filterProtocol)
            }
        }
    }
}
