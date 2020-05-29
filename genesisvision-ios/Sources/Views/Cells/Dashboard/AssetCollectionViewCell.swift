//
//  ProgramCollectionViewCell.swift
//  genesisvision-ios
//
//  Created by George on 13.12.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

struct AssetCollectionViewCellViewModel {
    let type: AssetType
    let asset: Codable?
    weak var filterProtocol: FilterChangedProtocol?
    weak var favoriteProtocol: FavoriteStateChangeProtocol?
    
    func getAssetId() -> String {
        var assetId: String = ""
        if let program = asset as? ProgramDetailsListItem, let id = program._id?.uuidString {
            assetId = id
        } else if let programInvesting = asset as? ProgramInvestingDetailsList, let id = programInvesting._id?.uuidString {
            assetId = id
        } else if let tradingAsset = asset as? DashboardTradingAsset, tradingAsset.assetType == type, let id = tradingAsset._id?.uuidString {
            assetId = id
        } else if let fund = asset as? FundDetailsListItem, let id = fund._id?.uuidString {
            assetId = id
        } else if let fundInvesting = asset as? FundInvestingDetailsList, let id = fundInvesting._id?.uuidString {
            assetId = id
        } else if let tradingAsset = asset as? DashboardTradingAsset, tradingAsset.assetType == type, let id = tradingAsset._id?.uuidString {
            assetId = id
        } else if let follow = asset as? FollowDetailsListItem {
            assetId = follow._id?.uuidString ?? ""
        } else if let tradingAsset = asset as? DashboardTradingAsset, tradingAsset.assetType == type {
            assetId = tradingAsset._id?.uuidString ?? ""
        }
        
        return assetId
    }
}

extension AssetCollectionViewCellViewModel: CellViewModel {
    func setup(on cell: AssetCollectionViewCell) {
        if let asset = asset as? ProgramDetailsListItem {
            cell.configure(asset, filterProtocol: filterProtocol, favoriteProtocol: favoriteProtocol)
        } else if let asset = asset as? FollowDetailsListItem {
            cell.configure(asset, filterProtocol: filterProtocol, favoriteProtocol: favoriteProtocol)
        } else if let asset = asset as? FundDetailsListItem {
            cell.configure(asset, filterProtocol: filterProtocol, favoriteProtocol: favoriteProtocol)
        } else if let asset = asset as? DashboardTradingAsset {
            cell.configure(asset, filterProtocol: filterProtocol)
        } else if let asset = asset as? FundInvestingDetailsList {
            cell.configure(asset, filterProtocol: filterProtocol, favoriteProtocol: favoriteProtocol)
        } else if let asset = asset as? ProgramInvestingDetailsList {
            cell.configure(asset, filterProtocol: filterProtocol, favoriteProtocol: favoriteProtocol)
        }
    }
}

class AssetCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Views
    @IBOutlet weak var stackView: UIStackView!
    
    var cellContentView: ContentViewProtocol!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    // MARK: - Public methods
    /// Fund
    /// - Parameters:
    ///   - asset: FundDetailsList
    ///   - delegate: FavoriteStateChangeProtocol
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
    ///   - asset: ProgramDetailsList
    ///   - delegate: FavoriteStateChangeProtocol
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
    ///   - asset: FollowDetailsList
    ///   - delegate: FavoriteStateChangeProtocol
    func configure(_ asset: FollowDetailsListItem, filterProtocol: FilterChangedProtocol?, favoriteProtocol: FavoriteStateChangeProtocol?) {
        stackView.removeAllArrangedSubviews()
        cellContentView = FollowContentView.viewFromNib()
        if let cellContentView = cellContentView as? FollowContentView {
            stackView.addArrangedSubview(cellContentView)
            cellContentView.configure(asset, filterProtocol: filterProtocol, favoriteProtocol: favoriteProtocol)
        }
    }
    
    /// FundInvesting
    /// - Parameters:
    ///   - asset: FundInvestingDetailsList
    ///   - delegate: FavoriteStateChangeProtocol
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
    ///   - delegate: FavoriteStateChangeProtocol
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
