//
//  WalletCurrencyTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 22/04/2019.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class WalletCurrencyTableViewCell: UITableViewCell {
    
    // MARK: - Variables
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: TitleLabel! {
        didSet {
            titleLabel.isHidden = true
            titleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet weak var subtitleLabel: SubtitleLabel! {
        didSet {
            subtitleLabel.isHidden = true
        }
    }
    @IBOutlet weak var selectedImageView: UIImageView! {
        didSet {
            selectedImageView.image = #imageLiteral(resourceName: "img_radio_unselected_icon")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = UIColor.Cell.bg
        backgroundColor = UIColor.Cell.bg
        tintColor = UIColor.Cell.title
        accessoryView?.backgroundColor = UIColor.Cell.bg
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: - Public methods
    func configure(_ wallet: WalletWithdrawalInfo? = nil, selected: Bool) {
        if let description = wallet?.description {
            titleLabel.isHidden = false
            titleLabel.text = description
        }
        
        if let currency = wallet?.currency {
            subtitleLabel.isHidden = false
            subtitleLabel.text = currency.rawValue
        }
        
        logoImageView.image = UIImage.walletPlaceholder
        
        if let fileName = wallet?.logo, let fileUrl = getFileURL(fileName: fileName) {
            logoImageView.kf.indicatorType = .activity
            logoImageView.kf.setImage(with: fileUrl, placeholder: UIImage.programPlaceholder)
        }
        
        selectedImageView.image = selected ? #imageLiteral(resourceName: "img_radio_selected_icon") : #imageLiteral(resourceName: "img_radio_unselected_icon")
    }
    
    func configure(_ wallet: WalletData? = nil, selected: Bool) {
        if let title = wallet?.title {
            titleLabel.isHidden = false
            titleLabel.text = title
        }
        
        if let currency = wallet?.currency {
            subtitleLabel.isHidden = false
            subtitleLabel.text = currency.rawValue
        }
        
        logoImageView.image = UIImage.walletPlaceholder
        
        if let fileName = wallet?.logo, let fileUrl = getFileURL(fileName: fileName) {
            logoImageView.kf.indicatorType = .activity
            logoImageView.kf.setImage(with: fileUrl, placeholder: UIImage.programPlaceholder)
        }
        
        selectedImageView.image = selected ? #imageLiteral(resourceName: "img_radio_selected_icon") : #imageLiteral(resourceName: "img_radio_unselected_icon")
    }
}
