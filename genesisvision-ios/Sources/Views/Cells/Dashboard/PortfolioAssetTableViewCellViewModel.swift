//
//  PortfolioAssetTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 24/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIColor

struct PortfolioAssetTableViewCellViewModel {
    let selectedChartAssets: AssetsValue
}

extension PortfolioAssetTableViewCellViewModel: CellViewModel {
    func setup(on cell: PortfolioAssetTableViewCell) {
        cell.coloredView.isHidden = true
        
        if let value = selectedChartAssets.title {
            cell.titleLabel.text = value
        }
        if let value = selectedChartAssets.value {
            cell.balanceLabel.text = value.rounded(withType: .gvt).toString() + " \(Constants.gvtString)"
        }
        if let value = selectedChartAssets.changeValue {
            cell.changeValueLabel.text = value.rounded(withType: .gvt).toString() + " \(Constants.gvtString)"
            cell.changeValueLabel.textColor = value == 0 ? UIColor.Cell.title : value > 0 ? UIColor.Cell.greenTitle : UIColor.Cell.redTitle
        }
        if let value = selectedChartAssets.changePercent {
            cell.changePercentLabel.text = value.rounded(withType: .undefined).toString() + "%"
            cell.changePercentLabel.textColor = value == 0 ? UIColor.Cell.title : value > 0 ? UIColor.Cell.greenTitle : UIColor.Cell.redTitle
        }
    }
}
