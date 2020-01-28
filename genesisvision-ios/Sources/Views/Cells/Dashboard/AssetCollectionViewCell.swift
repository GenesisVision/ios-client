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
    weak var delegate: FavoriteStateChangeProtocol?
    
    func getAssetId() -> String {
        var assetId: String = ""
        if let program = asset as? ProgramDetailsListItem, let id = program.id?.uuidString {
            assetId = id
        } else if let programInvesting = asset as? ProgramInvestingDetailsList, let id = programInvesting.id?.uuidString {
            assetId = id
        } else if let tradingAsset = asset as? DashboardTradingAsset, tradingAsset.assetType == type, let id = tradingAsset.id?.uuidString {
            assetId = id
        } else if let fund = asset as? FundDetailsListItem, let id = fund.id?.uuidString {
            assetId = id
        } else if let fundInvesting = asset as? FundInvestingDetailsList, let id = fundInvesting.id?.uuidString {
            assetId = id
        } else if let tradingAsset = asset as? DashboardTradingAsset, tradingAsset.assetType == type, let id = tradingAsset.id?.uuidString {
            assetId = id
        } else if let follow = asset as? FollowDetailsListItem {
            assetId = follow.id?.uuidString ?? ""
        } else if let tradingAsset = asset as? DashboardTradingAsset, tradingAsset.assetType == type {
            assetId = tradingAsset.id?.uuidString ?? ""
        }
        
        return assetId
    }
}

extension AssetCollectionViewCellViewModel: CellViewModel {
    func setup(on cell: AssetCollectionViewCell) {
        if let program = asset as? ProgramDetailsListItem {
            cell.configure(program: program, delegate: delegate)
        } else if let follow = asset as? FollowDetailsListItem {
            cell.configure(follow: follow, delegate: delegate)
        } else if let fund = asset as? FundDetailsListItem {
            cell.configure(fund: fund, delegate: delegate)
        } else if let trading = asset as? DashboardTradingAsset {
            cell.configure(trading: trading, delegate: delegate)
        } else if let fundInvesting = asset as? FundInvestingDetailsList {
            cell.configure(fundInvesting: fundInvesting, delegate: delegate)
        } else if let programInvesting = asset as? ProgramInvestingDetailsList {
            cell.configure(programInvesting: programInvesting, delegate: delegate)
        }
    }
}

class AssetCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Views
    @IBOutlet weak var stackView: UIStackView!
    
    var cellContentView: AssetContentView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func loadContentView() {
        stackView.removeAllArrangedSubviews()
        cellContentView = AssetContentView.viewFromNib()
        stackView.addArrangedSubview(cellContentView)
    }
    
    // MARK: - Public methods
    /// Fund
    /// - Parameters:
    ///   - asset: FundDetailsList
    ///   - delegate: FavoriteStateChangeProtocol
    func configure(fund asset: FundDetailsListItem, delegate: FavoriteStateChangeProtocol?) {
        loadContentView()
        cellContentView.configure(fund: asset, delegate: delegate)
    }
    
    /// Program
    /// - Parameters:
    ///   - asset: ProgramDetailsList
    ///   - delegate: FavoriteStateChangeProtocol
    func configure(program asset: ProgramDetailsListItem, delegate: FavoriteStateChangeProtocol?) {
        loadContentView()
        cellContentView.configure(program: asset, delegate: delegate)
    }
    
    /// Trading
    /// - Parameters:
    ///   - asset: DashboardTradingAsset
    ///   - delegate: FavoriteStateChangeProtocol
    func configure(trading asset: DashboardTradingAsset, delegate: FavoriteStateChangeProtocol?) {
        loadContentView()
        cellContentView.configure(trading: asset, delegate: delegate)
    }
    
    /// Follow
    /// - Parameters:
    ///   - asset: FollowDetailsList
    ///   - delegate: FavoriteStateChangeProtocol
    func configure(follow asset: FollowDetailsListItem, delegate: FavoriteStateChangeProtocol?) {
        loadContentView()
        cellContentView.configure(follow: asset, delegate: delegate)
    }
    
    
    /// FundInvesting
    /// - Parameters:
    ///   - asset: FundInvestingDetailsList
    ///   - delegate: FavoriteStateChangeProtocol
    func configure(fundInvesting asset: FundInvestingDetailsList, delegate: FavoriteStateChangeProtocol?) {
        loadContentView()
        cellContentView.configure(fund: asset, delegate: delegate)
    }
    
    /// ProgramInvesting
    /// - Parameters:
    ///   - asset: ProgramInvestingDetailsList
    ///   - delegate: FavoriteStateChangeProtocol
    func configure(programInvesting asset: ProgramInvestingDetailsList, delegate: FavoriteStateChangeProtocol?) {
        loadContentView()
        cellContentView.configure(program: asset, delegate: delegate)
    }
    
    
}
