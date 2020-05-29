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
    func configure(_ model: WalletWithdrawalInfo? = nil, selected: Bool) {
        setTitle(model?._description)
        setSubtitle(model?.currency?.rawValue)
        setImage(model?.logoUrl)
        
        changeSelected(selected)
    }
    
    func configure(_ model: WalletData? = nil, selected: Bool) {
        setTitle(model?.title)
        setSubtitle(model?.currency?.rawValue)
        setImage(model?.logoUrl)
        
        changeSelected(selected)
    }
    
    func configure(_ model: TradingAccountDetails? = nil, selected: Bool) {
        setTitle(model?.login)
        setSubtitle(model?.currency?.rawValue)
        setImage(model?.asset?.logoUrl)

        changeSelected(selected)
    }
    
    func configure(_ model: Broker? = nil, selected: Bool) {
        setTitle(model?.name)

        changeSelected(selected)
    }
    
    func configure(_ model: String? = nil, selected: Bool) {
        setTitle(model)
        
        changeSelected(selected)
    }

    func configure(_ model: Int? = nil, selected: Bool) {
        setTitle(model?.toString())
        
        changeSelected(selected)
    }
    
    func configure(_ model: BrokerAccountType? = nil, selected: Bool) {
        setTitle(model?.name)
        
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
