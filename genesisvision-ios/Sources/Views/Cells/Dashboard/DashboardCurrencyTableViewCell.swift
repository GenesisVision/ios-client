//
//  DashboardCurrencyTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 07/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class DashboardCurrencyTableViewCell: UITableViewCell {

    // MARK: - Variables
    @IBOutlet weak var currencyTitleLabel: UILabel! {
        didSet {
            currencyTitleLabel.textColor = UIColor.Cell.subtitle
            currencyRateLabel.font = UIFont.getFont(.regular, size: 15.0)
        }
    }
    @IBOutlet weak var currencyRateLabel: UILabel! {
        didSet {
            currencyRateLabel.textColor = UIColor.Cell.subtitle
            currencyRateLabel.font = UIFont.getFont(.regular, size: 15.0)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = UIColor.Cell.bg
        backgroundColor = UIColor.Cell.bg
        tintColor = UIColor.Cell.title
        accessoryView?.backgroundColor = UIColor.Cell.bg
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Public methods
    func configure(title: String, rate: String, selected: Bool) {
        currencyTitleLabel.text = title
        currencyRateLabel.text = rate
        currencyTitleLabel.textColor = selected ? UIColor.Cell.title : UIColor.Cell.subtitle
        currencyRateLabel.textColor = selected ? UIColor.Cell.title : UIColor.Cell.subtitle
        accessoryType = selected ? .checkmark : .none
    }
}
