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
                cell.entryImageView.image = #imageLiteral(resourceName: "img_entry_arrow_down")
            case .out, .outBy:
                cell.entryImageView.image = #imageLiteral(resourceName: "img_entry_arrow_up")
            }
        }
    }
}

