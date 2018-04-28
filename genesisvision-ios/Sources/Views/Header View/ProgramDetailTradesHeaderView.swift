//
//  ProgramDetailTradesTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 11/04/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class ProgramDetailTradesHeaderView: UITableViewHeaderFooterView {

    // MARK: - Labels
    @IBOutlet var dateOpenLabel: UILabel!
    @IBOutlet var dateCloseLabel: UILabel!
    
    @IBOutlet var symbolLabel: UILabel!
    @IBOutlet var volumeLabel: UILabel!
    
    @IBOutlet var priceOpenLabel: UILabel!
    @IBOutlet var priceCloseLabel: UILabel!
    
    @IBOutlet var profitLabel: UILabel!
    @IBOutlet var directionLabel: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor.Background.darkGray
    }
    
    // MARK: - Public methods
    func configure(isMetaTrader5: Bool) {
        if isMetaTrader5 {
            dateOpenLabel.text = "DATE"
            priceOpenLabel.text = "PRICE"
            
            dateCloseLabel.isHidden = true
            priceCloseLabel.isHidden = true    
        } else {
            dateCloseLabel.isHidden = false
            priceCloseLabel.isHidden = false
        }
    }
}
