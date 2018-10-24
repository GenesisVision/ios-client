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
    @IBOutlet weak var currencyTitleLabel: TitleLabel!
    @IBOutlet weak var currencyRateLabel: SubtitleLabel!
    @IBOutlet weak var selectedImageView: UIImageView! {
        didSet {
            selectedImageView.image = #imageLiteral(resourceName: "img_radio_unselected_icon")
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
    func configure(currencyValue: String, currencyRate: Double, selected: Bool) {
        let text = "1 GVT = \(currencyRate) " + currencyValue
        currencyTitleLabel.text = currencyValue
        currencyRateLabel.text = text
        selectedImageView.image = selected ? #imageLiteral(resourceName: "img_radio_selected_icon") : #imageLiteral(resourceName: "img_radio_unselected_icon")
    }
}
