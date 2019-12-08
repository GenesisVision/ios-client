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
    let isOpenTrades: Bool
    weak var delegate: SignalTradesProtocol?
}

extension SignalTradesTableViewCellViewModel: CellViewModel {
    func setup(on cell: SignalTradesTableViewCell) {
        cell.delegate = delegate
        cell.tradeId = orderModel.id?.uuidString
        
        if let provider = orderModel.providers?.first {
            if let program = provider.program {
                if let title = program.title {
                    cell.titleLabel.text = title
                }
                
                if let level = program.level {
                    cell.assetLogoImageView.levelButton.setTitle(level.toString(), for: .normal)
                }
                
                if let levelProgress = program.levelProgress {
                    cell.assetLogoImageView.levelButton.progress = levelProgress
                }
                
                if let color = program.color {
                    cell.assetLogoImageView.profilePhotoImageView.backgroundColor = UIColor.hexColor(color)
                }
                
                cell.assetLogoImageView.profilePhotoImageView.image = UIImage.programPlaceholder
                
                if let logo = program.logo, let fileUrl = getFileURL(fileName: logo) {
                    cell.assetLogoImageView.profilePhotoImageView.kf.indicatorType = .activity
                    cell.assetLogoImageView.profilePhotoImageView.kf.setImage(with: fileUrl, placeholder: UIImage.programPlaceholder)
                    cell.assetLogoImageView.profilePhotoImageView.backgroundColor = .clear
                }
            }
        }
        
        if let date = orderModel.date {
            cell.dateLabel.text = date.dateAndTimeToString()
        }
        
        cell.closeButton.isHidden = !isOpenTrades
        
        //price
        var priceValue = ""
        if isOpenTrades, let value = orderModel.priceCurrent {
            priceValue = value.toString()
        } else if let value = orderModel.price {
            priceValue = value.toString()
        }
        cell.priceLabel.text = priceValue
        
        //price open
        cell.priceOpenTitleLabel.text = "price open"
        cell.priceOpenTitleLabel.text = isOpenTrades ? "price open" : "commission"
        
        var priceOpenValue = ""
        if isOpenTrades, let value = orderModel.price {
            priceOpenValue = value.toString()
        } else if let value = orderModel.totalCommission {
            priceOpenValue = value.toString()
        }
        cell.priceOpenLabel.text = priceOpenValue
        
        //volume
        if let value = orderModel.volume {
            cell.volumeLabel.text = value.toString()
        }
        
        //profit
        if let currency = orderModel.currency, let currencyType = CurrencyType(rawValue: currency.rawValue), let value = orderModel.profit {
            cell.profitLabel.textColor = value == 0 ? UIColor.Cell.title : value > 0 ? UIColor.Cell.greenTitle : UIColor.Cell.redTitle
            cell.profitLabel.text = value.rounded(with: currencyType).toString() + " " + currencyType.rawValue
        }
        
        //dir
        if let value = orderModel.direction?.rawValue {
            cell.directionLabel.text = value
            cell.directionLabel.textColor = value == "Buy" ? UIColor.Cell.greenTitle : UIColor.Cell.redTitle
        }
        
        cell.dirEntryTitleLabel.text = isOpenTrades ? "dir" : "dir/entry"
        
        //entry
        cell.entryLabel.isHidden = isOpenTrades
        if !isOpenTrades, let entry = orderModel.entry {
            cell.entryLabel.text = " / " + entry.rawValue
        }
        
        //symbol
        if let value = orderModel.symbol {
            cell.symbolLabel.text = value
        }
    }
}


