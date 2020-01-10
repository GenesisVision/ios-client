//
//  InfoSubscriptionTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 08.01.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import UIKit

class InfoSubscriptionTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: TitleLabel! {
        didSet {
            titleLabel.font = UIFont.getFont(.semibold, size: 18.0)
        }
    }
    //Subscription details
    @IBOutlet weak var subscriptionStackView: UIStackView! {
        didSet {
            subscriptionStackView.isHidden = false
        }
    }
    
    @IBOutlet weak var valueStackView: UIStackView!
    @IBOutlet weak var valueValueLabel: TitleLabel! {
        didSet {
            valueValueLabel.textColor = UIColor.primary
        }
    }
    @IBOutlet weak var valueTitleLabel: SubtitleLabel!
    
    @IBOutlet weak var profitStackView: UIStackView!
    @IBOutlet weak var profitValueLabel: TitleLabel!
    @IBOutlet weak var profitTitleLabel: SubtitleLabel!
    
    @IBOutlet weak var statusStackView: UIStackView!
    @IBOutlet weak var statusValueLabel: TitleLabel!
    @IBOutlet weak var statusTitleLabel: SubtitleLabel!
    
    @IBOutlet weak var typeStackView: UIStackView!
    @IBOutlet weak var typeValueLabel: TitleLabel! {
        didSet {
            typeValueLabel.textColor = UIColor.primary
        }
    }
    @IBOutlet weak var typeTitleLabel: SubtitleLabel!
    
    @IBOutlet weak var editButton: UIButton! {
        didSet {
            editButton.isHidden = true
        }
    }
    
    weak var infoSignalsProtocol: InfoSignalsProtocol?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
    }
    
    // MARK: - Actions
    @IBAction func editButtonAction(_ sender: UIButton) {
        infoSignalsProtocol?.didTapEditButton()
    }
}
