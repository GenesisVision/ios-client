//
//  TradesTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 11.04.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import UIKit.UIColor

struct TradesTableViewCellViewModel {
    let orderModel: Codable?
    let currencyType: CurrencyType
}

extension TradesTableViewCellViewModel: CellViewModel {
    func setup(on cell: TradesTableViewCell) {
        if let orderModel = orderModel as? OrderSignalModel {
            if let value = orderModel.price {
                cell.balanceLabel.text = value.toString()
            }
            
            if let value = orderModel.profit {
                cell.profitLabel.textColor = value == 0 ? UIColor.Cell.title : value > 0 ? UIColor.Cell.greenTitle : UIColor.Cell.redTitle
                cell.profitLabel.text = value.rounded(with: currencyType).toString() + " " + currencyType.rawValue
            }
            
            if let value = orderModel.direction?.rawValue {
                cell.directionLabel.text = value
            }
            
            if let value = orderModel.symbol {
                cell.symbolLabel.text = value
            }
            
            if let logoUrl = orderModel.assetData?.logoUrl, let fileUrl = getFileURL(fileName: logoUrl) {
                cell.entryImageView.kf.indicatorType = .activity
                cell.entryImageView.kf.setImage(with: fileUrl)
            } else if let entry = orderModel.entry {
                switch entry {
                case ._in, ._inout:
                    cell.entryImageView.image = #imageLiteral(resourceName: "img_trade_in")
                case .out, .outBy:
                    cell.entryImageView.image = #imageLiteral(resourceName: "img_trade_out")
                }
            }
        } else if let orderModel = orderModel as? OrderModel {
            if let price = orderModel.price {
                cell.balanceLabel.text = price.toString()
            }
            
            if let price = orderModel.price, price == 0, let volume = orderModel.volume {
                cell.balanceLabel.text = volume.toString()
            }
            
            if let value = orderModel.profit {
                cell.profitLabel.textColor = value == 0 ? UIColor.Cell.title : value > 0 ? UIColor.Cell.greenTitle : UIColor.Cell.redTitle
                cell.profitLabel.text = value.rounded(with: currencyType).toString() + " " + currencyType.rawValue
            }
            
            if let value = orderModel.direction?.rawValue {
                cell.directionLabel.text = value
            }
            
            if let value = orderModel.symbol {
                cell.symbolLabel.text = value
            }
            
            if let logoUrl = orderModel.assetData?.logoUrl, let fileUrl = getFileURL(fileName: logoUrl) {
                cell.entryImageView.kf.indicatorType = .activity
                cell.entryImageView.kf.setImage(with: fileUrl)
            } else if let entry = orderModel.entry {
                switch entry {
                case ._in, ._inout:
                    cell.entryImageView.image = #imageLiteral(resourceName: "img_trade_in")
                case .out, .outBy:
                    cell.entryImageView.image = #imageLiteral(resourceName: "img_trade_out")
                }
            }
        }
        
    }
}

