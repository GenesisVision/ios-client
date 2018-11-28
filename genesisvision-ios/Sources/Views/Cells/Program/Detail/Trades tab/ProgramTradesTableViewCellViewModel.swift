//
//  ProgramTradesTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 11.04.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import UIKit.UIColor

struct ProgramTradesTableViewCellViewModel {
    let orderModel: OrderModel
}

extension ProgramTradesTableViewCellViewModel: CellViewModel {
    func setup(on cell: ProgramTradesTableViewCell) {
        if let value = orderModel.price {
            cell.balanceLabel.text = value.toString()
        }
        
        if let value = orderModel.profit {
            cell.profitLabel.textColor = value >= 0 ? UIColor.Cell.greenTitle : UIColor.Cell.redTitle
            cell.profitLabel.text = value.toString()
        }
        
        if let value = orderModel.direction?.rawValue {
            cell.directionLabel.text = value
        }
        
        if let value = orderModel.symbol {
            cell.symbolLabel.text = value
        }
        
        if let entry = orderModel.entry {
            switch entry {
            case ._in, ._inout:
                cell.entryImageView.image = #imageLiteral(resourceName: "img_trade_in")
            case .out, .outBy:
                cell.entryImageView.image = #imageLiteral(resourceName: "img_trade_out")
            }
        }
    }
}

