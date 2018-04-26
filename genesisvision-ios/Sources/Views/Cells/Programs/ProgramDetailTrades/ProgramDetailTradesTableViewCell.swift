//
//  ProgramDetailTradesTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 11/04/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class ProgramDetailTradesTableViewCell: PlateTableViewCell {

    // MARK: - Labels
    @IBOutlet var dateOpenLabel: UILabel!
    @IBOutlet var dateCloseLabel: UILabel!
    
    @IBOutlet var symbolLabel: UILabel!
    @IBOutlet var volumeLabel: UILabel!
    
    @IBOutlet var priceOpenLabel: UILabel!
    @IBOutlet var priceCloseLabel: UILabel!
    
    @IBOutlet var profitLabel: UILabel!
    @IBOutlet var directionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
