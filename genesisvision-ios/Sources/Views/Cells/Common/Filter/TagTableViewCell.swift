//
//  TagTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 08/07/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class TagTableViewCell: UITableViewCell {
    
    // MARK: - Variables
    @IBOutlet weak var logoImageView: UIImageView! {
        didSet {
            logoImageView.isHidden = true
        }
    }
    
    @IBOutlet weak var titleLabel: TitleLabel! {
        didSet {
            titleLabel.isHidden = true
            titleLabel.font = UIFont.getFont(.regular, size: 14.0)
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
    
    // MARK: - Public methods
    func configure(_ selected: Bool, tag: Tag? = nil) {
        logoImageView.isHidden = true
        
        if let title = tag?.name {
            titleLabel.isHidden = false
            titleLabel.text = title
        }
        
        selectedImageView.image = selected ? #imageLiteral(resourceName: "img_radio_selected_icon") : #imageLiteral(resourceName: "img_radio_unselected_icon")
    }
    
    func configure(_ selected: Bool, asset: PlatformAsset? = nil) {
        if let logo = asset?.icon, let fileUrl = getFileURL(fileName: logo) {
            logoImageView.isHidden = false
            
            let placeholder = UIImage.fundPlaceholder
            logoImageView.image = placeholder
            logoImageView.kf.indicatorType = .activity
            logoImageView.kf.setImage(with: fileUrl, placeholder: placeholder)
            logoImageView.backgroundColor = .clear
        }
        
        if let title = asset?.asset {
            titleLabel.isHidden = false
            titleLabel.text = title
        }
        
        selectedImageView.image = selected ? #imageLiteral(resourceName: "img_radio_selected_icon") : #imageLiteral(resourceName: "img_radio_unselected_icon")
    }
}

