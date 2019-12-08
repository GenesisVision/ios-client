//
//  PortfolioAssetTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 24/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIColor

struct PortfolioAssetTableViewCellViewModel {
    let assetsValue: AssetsValue?
    let otherAssetsValue: OtherAssetsValue?
}

extension PortfolioAssetTableViewCellViewModel: CellViewModel {
    func setup(on cell: PortfolioAssetTableViewCell) {
        cell.coloredView.isHidden = true
        
        if let assetsValue = assetsValue {
            
            if let color = assetsValue.color {
                cell.coloredView.isHidden = false
                cell.coloredView.backgroundColor = UIColor.hexColor(color)
            }
            
            if let value = assetsValue.title {
                cell.titleLabel.text = value
            }
            if let value = assetsValue.value {
                cell.balanceLabel.text = value.rounded(with: .gvt).toString() + " \(Constants.gvtString)"
            }
            if let value = assetsValue.changeValue {
                cell.changeValueLabel.text = value.rounded(with: .gvt).toString() + " \(Constants.gvtString)"
                cell.changeValueLabel.textColor = value == 0 ? UIColor.Cell.title : value > 0 ? UIColor.Cell.greenTitle : UIColor.Cell.redTitle
            }
            if let value = assetsValue.changePercent {
                cell.changePercentLabel.text = value.rounded(with: .undefined).toString() + "%"
                cell.changePercentLabel.textColor = value == 0 ? UIColor.Cell.title : value > 0 ? UIColor.Cell.greenTitle : UIColor.Cell.redTitle
            }
        }
        
        if let otherAssetsValue = otherAssetsValue {
            cell.titleLabel.text = "Others"
            
            cell.coloredView.isHidden = false
            cell.coloredView.backgroundColor = UIColor.Cell.title
            
            if let value = otherAssetsValue.value {
                cell.balanceLabel.text = value.rounded(with: .gvt).toString() + " \(Constants.gvtString)"
            }
            if let value = otherAssetsValue.changeValue {
                cell.changeValueLabel.text = value.rounded(with: .gvt).toString() + " \(Constants.gvtString)"
                cell.changeValueLabel.textColor = value == 0 ? UIColor.Cell.title : value > 0 ? UIColor.Cell.greenTitle : UIColor.Cell.redTitle
            }
            if let value = otherAssetsValue.changePercent {
                cell.changePercentLabel.text = value.rounded(with: .undefined).toString() + "%"
                cell.changePercentLabel.textColor = value == 0 ? UIColor.Cell.title : value > 0 ? UIColor.Cell.greenTitle : UIColor.Cell.redTitle
            }
        }
    }
}
