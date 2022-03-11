//
//  FundTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 25/10/18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import Kingfisher

struct ProgramTableViewCellViewModel {
    var asset: ProgramDetailsListItem
    weak var filterProtocol: FilterChangedProtocol?
    weak var favoriteProtocol: FavoriteStateChangeProtocol?
}

extension ProgramTableViewCellViewModel: CellViewModel {
    func setup(on cell: AssetTableViewCell) {
        cell.configure(asset, filterProtocol: filterProtocol, favoriteProtocol: favoriteProtocol)
    }
}

struct FundTableViewCellViewModel {
    var asset: FundDetailsListItem
    weak var filterProtocol: FilterChangedProtocol?
    weak var favoriteProtocol: FavoriteStateChangeProtocol?
}

extension FundTableViewCellViewModel: CellViewModel {
    func setup(on cell: AssetTableViewCell) {
        cell.configure(asset, filterProtocol: filterProtocol, favoriteProtocol: favoriteProtocol)
    }
}

struct FollowTableViewCellViewModel {
    var asset: FollowDetailsListItem
    weak var filterProtocol: FilterChangedProtocol?
    weak var favoriteProtocol: FavoriteStateChangeProtocol?
}

extension FollowTableViewCellViewModel: CellViewModel {
    func setup(on cell: AssetTableViewCell) {
        cell.configure(asset, filterProtocol: filterProtocol, favoriteProtocol: favoriteProtocol)
    }
}

struct CoinAssetTableViewCellViewModel {
    var asset: CoinsAsset
    weak var filterProtocol: FilterChangedProtocol?
    weak var favoriteProtocol: FavoriteStateChangeProtocol?
}

extension CoinAssetTableViewCellViewModel: CellViewModel {
    func setup(on cell: AssetTableViewCell) {
        cell.configure(asset, filterProtocol: filterProtocol, favoriteProtocol: favoriteProtocol)
    }
}

struct TradingTableViewCellViewModel {
    let asset: DashboardTradingAsset
    weak var filterProtocol: FilterChangedProtocol?
}

extension TradingTableViewCellViewModel: CellViewModel {
    func setup(on cell: AssetTableViewCell) {
        cell.configure(asset, filterProtocol: filterProtocol)
    }
}

struct FundInvestingTableViewCellViewModel {
    let asset: FundInvestingDetailsList
    weak var filterProtocol: FilterChangedProtocol?
    weak var favoriteProtocol: FavoriteStateChangeProtocol?
}

extension FundInvestingTableViewCellViewModel: CellViewModel {
    func setup(on cell: AssetTableViewCell) {
        cell.configure(asset, filterProtocol: filterProtocol, favoriteProtocol: favoriteProtocol)
    }
}

struct ProgramInvestingTableViewCellViewModel {
    let asset: ProgramInvestingDetailsList
    weak var filterProtocol: FilterChangedProtocol?
    weak var favoriteProtocol: FavoriteStateChangeProtocol?
}

extension ProgramInvestingTableViewCellViewModel: CellViewModel {
    func setup(on cell: AssetTableViewCell) {
        cell.configure(asset, filterProtocol: filterProtocol, favoriteProtocol: favoriteProtocol)
    }
}
