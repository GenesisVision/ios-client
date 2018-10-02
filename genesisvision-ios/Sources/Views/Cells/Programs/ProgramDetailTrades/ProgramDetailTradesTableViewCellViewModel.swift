//
//  ProgramDetailTradesTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 11.04.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import UIKit.UIColor

struct ProgramDetailTradesTableViewCellViewModel {
    let orderModel: OrderModel
}

extension ProgramDetailTradesTableViewCellViewModel: CellViewModel {
    func setup(on cell: ProgramDetailTradesTableViewCell) {
//        if let date = orderModel.date {
//            cell.dateOpenLabel.text = date.dateAndTimeFormatString
//            cell.dateCloseLabel.isHidden = true
//        } else if let dateOpen = orderModel.dateOpen, let dateClose = orderModel.dateClose {
//            cell.dateOpenLabel.text = dateOpen.dateAndTimeFormatString
//            cell.dateCloseLabel.text = dateClose.dateAndTimeFormatString
//        }
//        
//        if let price = orderModel.price {
//            cell.priceOpenLabel.text = price.toString()
//            cell.priceCloseLabel.isHidden = true
//        } else if let priceOpen = orderModel.priceOpen, let priceClose = orderModel.priceClose {
//            cell.priceOpenLabel.text = priceOpen.toString()
//            cell.priceCloseLabel.text = priceClose.toString()
//        }
//        
//        if let symbol = orderModel.symbol {
//            cell.symbolLabel.text = symbol
//        }
//        
//        if let volume = orderModel.volume {
//            cell.volumeLabel.text = volume.toString()
//        }
//        
//        if let profit = orderModel.profit {
//            cell.profitLabel.textColor = profit >= 0 ? UIColor.Font.primary : UIColor.Font.red
//            cell.profitLabel.text = profit.toString()
//        }
//        
//        if let direction = orderModel.direction?.rawValue {
//            cell.directionLabel.text = direction
//        }
//        
//        if let entry = orderModel.entry {
//            cell.directionLabel.text?.append(" " + entry.rawValue)
//        }
    }
}

