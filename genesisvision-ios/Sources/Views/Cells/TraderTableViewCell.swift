//
//  TraderTableViewCell.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class ProfileImageView: UIView {
    @IBOutlet var profilePhotoImageView: RoundedImageView! {
        didSet {
            profilePhotoImageView.roundCorners()
            profilePhotoImageView.image = #imageLiteral(resourceName: "gv_logo") //placeholder
        }
    }
    
    @IBOutlet var flagImageView: RoundedImageView! {
        didSet {
            guard let _ = flagImageView.image else { return }
            flagImageView.addBorder(withBorderWidth: 1.0)
        }
    }
    
    @IBOutlet var levelLabel: UILabel! {
        didSet {
            levelLabel.roundWithBorder(1.0)
        }
    }
}

class TraderTableViewCell: UITableViewCell {
    
    @IBOutlet var profileImageView: ProfileImageView!
    
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
        
        backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.9372549057, blue: 0.9568627477, alpha: 1)
    }
}
