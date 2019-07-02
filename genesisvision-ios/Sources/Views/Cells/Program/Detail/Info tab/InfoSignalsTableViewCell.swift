//
//  InfoSignalsTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 20/02/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

protocol InfoSignalsProtocol: class {
    func didTapFollowButton()
    func didTapEditButton()
}

class InfoSignalsTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: TitleLabel! {
        didSet {
            titleLabel.font = UIFont.getFont(.semibold, size: 18.0)
        }
    }
    //Signal details
    @IBOutlet weak var signalStackView: UIStackView! {
        didSet {
            signalStackView.isHidden = true
        }
    }
    
    @IBOutlet weak var subscriptionFeeStackView: UIStackView!
    @IBOutlet weak var subscriptionFeeValueLabel: TitleLabel!
    @IBOutlet weak var subscriptionFeeTitleLabel: SubtitleLabel!
    
    @IBOutlet weak var successFeeStackView: UIStackView!
    @IBOutlet weak var successFeeValueLabel: TitleLabel!
    @IBOutlet weak var successFeeTitleLabel: SubtitleLabel!
    
    //Subscription details
    @IBOutlet weak var subscriptionStackView: UIStackView! {
        didSet {
            subscriptionStackView.isHidden = true
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
    
    
    @IBOutlet weak var followButton: ActionButton! {
        didSet {
            followButton.setEnabled(AuthManager.isLogin())
        }
    }
    
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
    @IBAction func followButtonAction(_ sender: UIButton) {
        infoSignalsProtocol?.didTapFollowButton()
    }
    
    @IBAction func editButtonAction(_ sender: UIButton) {
        infoSignalsProtocol?.didTapEditButton()
    }
}
