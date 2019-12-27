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
    let asset: ProgramDetailsListItem
    weak var delegate: FavoriteStateChangeProtocol?
}

extension ProgramTableViewCellViewModel: CellViewModel {
    func setup(on cell: AssetTableViewCell) {
        cell.configure(program: asset, delegate: delegate)
    }
}

struct FundTableViewCellViewModel {
    let asset: FundDetailsListItem
    weak var delegate: FavoriteStateChangeProtocol?
}

extension FundTableViewCellViewModel: CellViewModel {
    func setup(on cell: AssetTableViewCell) {
        cell.configure(fund: asset, delegate: delegate)
    }
}

struct FollowTableViewCellViewModel {
    let asset: FollowDetailsListItem
    weak var delegate: FavoriteStateChangeProtocol?
}

extension FollowTableViewCellViewModel: CellViewModel {
    func setup(on cell: AssetTableViewCell) {
        cell.configure(follow: asset, delegate: delegate)
    }
}

struct TradingTableViewCellViewModel {
    let asset: DashboardTradingAsset
    weak var delegate: FavoriteStateChangeProtocol?
}

extension TradingTableViewCellViewModel: CellViewModel {
    func setup(on cell: AssetTableViewCell) {
        cell.configure(trading: asset, delegate: delegate)
    }
}

struct FundInvestingTableViewCellViewModel {
    let asset: FundInvestingDetailsList
    weak var delegate: FavoriteStateChangeProtocol?
}

extension FundInvestingTableViewCellViewModel: CellViewModel {
    func setup(on cell: AssetTableViewCell) {
        cell.configure(fund: asset, delegate: delegate)
    }
}

struct ProgramInvestingTableViewCellViewModel {
    let asset: ProgramInvestingDetailsList
    weak var delegate: FavoriteStateChangeProtocol?
}

extension ProgramInvestingTableViewCellViewModel: CellViewModel {
    func setup(on cell: AssetTableViewCell) {
        cell.configure(program: asset, delegate: delegate)
    }
}
