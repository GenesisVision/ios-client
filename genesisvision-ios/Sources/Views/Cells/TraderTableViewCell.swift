//
//  TraderTableViewCell.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class TraderTableViewCell: UITableViewCell {
    
    @IBOutlet var profilePhotoImageView: RoundedImageView! {
        didSet {
            profilePhotoImageView.roundCorners()
            profilePhotoImageView.image = #imageLiteral(resourceName: "gv_logo")
        }
    }
    
    @IBOutlet var levelLabel: UILabel! {
        didSet {
            levelLabel.roundWithBorder(1.0, color: .white)
        }
    }
    
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
    
    
    @IBOutlet var chartImageView: UIImageView! //TODO: change on Chart View
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profilePhotoImageView.cornerSize = profilePhotoImageView.frame.size.height / 2
    }
}
