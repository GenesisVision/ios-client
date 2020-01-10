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
            signalStackView.isHidden = false
        }
    }
    
    @IBOutlet weak var subscriptionFeeStackView: UIStackView!
    @IBOutlet weak var subscriptionFeeValueLabel: TitleLabel!
    @IBOutlet weak var subscriptionFeeTitleLabel: SubtitleLabel!
    
    @IBOutlet weak var successFeeStackView: UIStackView!
    @IBOutlet weak var successFeeValueLabel: TitleLabel!
    @IBOutlet weak var successFeeTitleLabel: SubtitleLabel!
    
    @IBOutlet weak var followButton: ActionButton!
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
    
    // MARK: - Actions
    @IBAction func editButtonAction(_ sender: UIButton) {
        infoSignalsProtocol?.didTapEditButton()
    }
}
