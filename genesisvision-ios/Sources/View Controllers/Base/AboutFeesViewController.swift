//
//  AboutFeesViewController.swift
//  genesisvision-ios
//
//  Created by George on 25/02/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class AboutFeesViewController: BaseViewController {
    
    // MARK: - Buttons
    @IBOutlet weak var textLabel: SubtitleLabel! {
        didSet {
            textLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    
    @IBOutlet weak var disclaimerLabel: SubtitleLabel! {
        didSet {
            disclaimerLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    
    
    @IBOutlet weak var feesView: UIView! {
        didSet {
            feesView.roundCorners(with: Constants.SystemSizes.cornerSize)
            feesView.backgroundColor = UIColor.Cell.bg
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private methods
    private func setupUI() {
        title = "Fees and Discounts"
        
        let text = "Any Genesis Vision user who holds a certain amount of GVT for 7 days receives a discount for transaction fees. The size of a discount can vary and depends on the amount of GVT that is being held. The regular trading fee is 0.3%, and the information on the tiered discount system can be found in the Genesis Vision Trading Conditions section.\n\nUsers of the Genesis Vision copy trading feature who hold any GVT on the Genesis Vision balance are eligible for discounts and also have the platform success fee of 10% for both investment programs and copy trading signals reduced by 1% for each 1000 GVT held."
        
        textLabel.text = text
        textLabel.setLineSpacing(lineSpacing: 3.0)
        
        disclaimerLabel.text = "* Please note that to be eligible for a discount tier you should hold GVT on your Genesis Vision wallet for at least 7 days"
        disclaimerLabel.setLineSpacing(lineSpacing: 3.0)
    }
}
