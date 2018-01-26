//
//  TraderTableViewCell.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class TraderTableViewCell: UITableViewCell {
    
    // MARK: - Views
    @IBOutlet var profileImageView: ProfileImageView!
    @IBOutlet var chartImageView: UIImageView! //TODO: change on Chart View
    
    // MARK: - Labels
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var currencyLabel: UILabel! {
        didSet {
            currencyLabel.addBorder(withBorderWidth: 1.0, color: UIColor(.blue))
        }
    }
    
    @IBOutlet var depositLabel: UILabel!
    @IBOutlet var tradesLabel: UILabel!
    @IBOutlet var weeksLabel: UILabel!
    @IBOutlet var profitLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.9372549057, blue: 0.9568627477, alpha: 1)
    }
}
