//
//  SelectableTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 22/04/2019.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class SelectableTableViewCell: UITableViewCell {
    
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
        setTitle(wallet?.description)
        setSubtitle(wallet?.currency?.rawValue)
        setImage(wallet?.logo)
        
        changeSelected(selected)
    }
    
    func configure(_ wallet: WalletData? = nil, selected: Bool) {
        setTitle(wallet?.title)
        setSubtitle(wallet?.currency?.rawValue)
        setImage(wallet?.logo)
        
        changeSelected(selected)
    }
    
    func configure(_ account: CopyTradingAccountInfo? = nil, selected: Bool) {
        setTitle(account?.title)
        setSubtitle(account?.currency?.rawValue)
        setImage(account?.logo)

        changeSelected(selected)
    }
    
    func configure(_ title: String? = nil, selected: Bool) {
        setTitle(title)
        setImage(nil)
        
        changeSelected(selected)
    }

    func configure(_ title: Int? = nil, selected: Bool) {
        setTitle(title?.toString())
        setImage(nil)
        
        changeSelected(selected)
    }

    
    // MARK: - Private methods
    private func setTitle(_ title: String?) {
        if let title = title {
            titleLabel.isHidden = false
            titleLabel.text = title
        }
    }
    
    private func setSubtitle(_ subtitle: String?) {
        if let subtitle = subtitle {
            subtitleLabel.isHidden = false
            subtitleLabel.text = subtitle
        }
    }
    
    private func changeSelected(_ selected: Bool) {
        selectedImageView.image = selected ? #imageLiteral(resourceName: "img_radio_selected_icon") : #imageLiteral(resourceName: "img_radio_unselected_icon")
    }
    
    private func setImage(_ logo: String?) {
        guard let fileName = logo else {
            logoImageView.isHidden = true
            return
        }
        
        logoImageView.image = UIImage.walletPlaceholder
        
        if let fileUrl = getFileURL(fileName: fileName) {
            logoImageView.kf.indicatorType = .activity
            logoImageView.kf.setImage(with: fileUrl, placeholder: UIImage.walletPlaceholder)
        }
    }
}
