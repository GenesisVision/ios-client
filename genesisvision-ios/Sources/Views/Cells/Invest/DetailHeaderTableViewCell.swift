//
//  DetailHeaderTableViewCell.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 11.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class DetailHeaderTableViewCell: UITableViewCell {

    // MARK: - Views
    @IBOutlet var programLogoImageView: ProfileImageView!
    
    // MARK: - Labels
    @IBOutlet var depositLabel: UILabel!
    @IBOutlet var tradesLabel: UILabel!
    @IBOutlet var weeksLabel: UILabel!
    @IBOutlet var profitLabel: UILabel!
    
    @IBOutlet var depositValueLabel: UILabel!
    @IBOutlet var tradesValueLabel: UILabel!
    @IBOutlet var weeksValueLabel: UILabel!
    @IBOutlet var profitValueLabel: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.Background.main
        contentView.backgroundColor = UIColor.Background.main
        selectionStyle = .none
    }
    
}
