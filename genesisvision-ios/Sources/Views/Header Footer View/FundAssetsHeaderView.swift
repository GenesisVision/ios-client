//
//  FundAssetsHeaderView.swift
//  genesisvision-ios
//
//  Created by George on 29/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class FundAssetsHeaderView: UITableViewHeaderFooterView {

    // MARK: - Labels
    @IBOutlet var firstTitleLabel: SubtitleLabel! {
        didSet {
            firstTitleLabel.isHidden = true
        }
    }
    @IBOutlet var secondTitleLabel: SubtitleLabel! {
        didSet {
            secondTitleLabel.isHidden = true
        }
    }
    @IBOutlet var thirdTitleLabel: SubtitleLabel! {
        didSet {
            thirdTitleLabel.isHidden = true
        }
    }
    @IBOutlet var fourthTitleLabel: SubtitleLabel! {
        didSet {
            fourthTitleLabel.isHidden = true
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = UIColor.BaseView.bg
    }
    
    // MARK: - Public methods
    func configure(firstTitle: String? = nil,
                   secondTitle: String? = nil,
                   thirdTitle: String? = nil,
                   fourthTitle: String? = nil) {
        
        if let firstTitle = firstTitle {
            firstTitleLabel.isHidden = false
            firstTitleLabel.text = firstTitle
        }
        
        if let secondTitle = secondTitle {
            secondTitleLabel.isHidden = false
            secondTitleLabel.text = secondTitle
        }
        
        if let thirdTitle = thirdTitle {
            thirdTitleLabel.isHidden = false
            thirdTitleLabel.text = thirdTitle
        }
        
        if let fourthTitle = fourthTitle {
            fourthTitleLabel.isHidden = false
            fourthTitleLabel.text = fourthTitle
        }
    }
}
