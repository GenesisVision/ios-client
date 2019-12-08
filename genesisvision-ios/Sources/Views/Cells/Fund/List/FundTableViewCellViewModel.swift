//
//  FundTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 25/10/18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import Kingfisher

struct FundTableViewCellViewModel {
    let asset: FundDetails
    weak var delegate: FavoriteStateChangeProtocol?
}

extension FundTableViewCellViewModel: CellViewModel {
    func setup(on cell: ProgramTableViewCell) {
        cell.configure(dashboardFund: asset, delegate: delegate)
    }
}
