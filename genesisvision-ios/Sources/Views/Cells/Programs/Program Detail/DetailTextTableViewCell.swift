//
//  DetailTextTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 27/04/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class DetailTextTableViewCell: PlateTableViewCell {

    // MARK: - Outlets
    @IBOutlet var availableTokensTooltip: TooltipButton! {
        didSet {
            availableTokensTooltip.tooltipText = String.Tooltitps.availableTokens
        }
    }
    
    // MARK: - Labels
    @IBOutlet var currencyLabel: CurrencyLabel!
    @IBOutlet var availableToInvestLabel: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        
    }
    
}
