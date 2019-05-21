//
//  SignalTradesTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 21/05/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import Foundation
import UIKit.UIColor

struct SignalTradesTableViewCellViewModel {
    let orderModel: OrderSignalModel
    let currencyType: CurrencyType
}

extension SignalTradesTableViewCellViewModel: CellViewModel {
    func setup(on cell: ProgramTradesTableViewCell) {
        if let value = orderModel.price {
            cell.balanceLabel.text = value.toString()
        }
        
        if let value = orderModel.profit {
            cell.profitLabel.textColor = value == 0 ? UIColor.Cell.title : value > 0 ? UIColor.Cell.greenTitle : UIColor.Cell.redTitle
            cell.profitLabel.text = value.rounded(withType: currencyType).toString() + " " + currencyType.rawValue
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


