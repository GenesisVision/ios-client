//
//  WalletTransactionView.swift
//  genesisvision-ios
//
//  Created by George on 26/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

protocol WalletTransactionViewProtocol: class {
    func copyAddressButtonDidPress()
    func copyHashButtonDidPress()
}

class WalletTransactionView: UIView {
    // MARK: - Variables
    weak var delegate: WalletTransactionViewProtocol?
    
    
    // MARK: - Outlets
    @IBOutlet weak var typeImageView: UIImageView! {
        didSet {
            typeImageView.roundCorners()
        }
    }
    @IBOutlet weak var titleLabel: SubtitleLabel! {
        didSet {
            titleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet weak var subtitleLabel: TitleLabel! {
        didSet {
            subtitleLabel.font = UIFont.getFont(.semibold, size: 14.0)
        }
    }
    
    @IBOutlet weak var firstTitleLabel: SubtitleLabel! {
        didSet {
            firstTitleLabel.font = UIFont.getFont(.regular, size: 12.0)
        }
    }
    @IBOutlet weak var firstValueLabel: TitleLabel! {
        didSet {
            firstValueLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet weak var firstStackView: UIStackView!
    
    @IBOutlet weak var secondTitleLabel: SubtitleLabel! {
        didSet {
            secondTitleLabel.font = UIFont.getFont(.regular, size: 12.0)
        }
    }
    @IBOutlet weak var secondValueLabel: TitleLabel! {
        didSet {
            secondValueLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet weak var secondStackView: UIStackView!
    
    @IBOutlet weak var copyAddressButton: UIButton! {
        didSet {
            copyAddressButton.setTitleColor(UIColor.Cell.title, for: .normal)
            copyAddressButton.titleLabel?.font = UIFont.getFont(.semibold, size: 12.0)
        }
    }
    @IBOutlet weak var copyHashButton: UIButton! {
        didSet {
            copyHashButton.setTitleColor(UIColor.Cell.title, for: .normal)
            copyHashButton.titleLabel?.font = UIFont.getFont(.semibold, size: 12.0)
        }
    }
    
    @IBOutlet weak var thirdTitleLabel: SubtitleLabel! {
        didSet {
            thirdTitleLabel.font = UIFont.getFont(.regular, size: 12.0)
        }
    }
    @IBOutlet weak var thirdValueLabel: TitleLabel! {
        didSet {
            thirdValueLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet weak var thirdStackView: UIStackView!
    
    @IBOutlet weak var fourthTitleLabel: SubtitleLabel! {
        didSet {
            fourthTitleLabel.font = UIFont.getFont(.regular, size: 12.0)
        }
    }
    @IBOutlet weak var fourthValueLabel: TitleLabel! {
        didSet {
            fourthValueLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet weak var fourthStackView: UIStackView!

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.Cell.bg
    }
    
    // MARK: - Public Methods
    func configure(_ model: TransactionDetails) {
        if let details = model.programDetails, let managerName = model.programDetails?.managerName {
            if let title = details.title {
                titleLabel.text = title
                subtitleLabel.text = managerName
            }
            
            if let color = details.color {
                typeImageView.backgroundColor = UIColor.hexColor(color)
            }
            
            typeImageView.image = UIImage.programPlaceholder
            
            if let logo = details.logo, let fileUrl = getFileURL(fileName: logo) {
                typeImageView.kf.indicatorType = .activity
                typeImageView.kf.setImage(with: fileUrl, placeholder: UIImage.programPlaceholder)
                typeImageView.backgroundColor = .clear
            }
        }
        
        if let details = model.convertingDetails {
            typeImageView.image = UIImage.programPlaceholder
            
            if let logo = details.currencyToLogo, let fileUrl = getFileURL(fileName: logo) {
                typeImageView.kf.indicatorType = .activity
                typeImageView.kf.setImage(with: fileUrl, placeholder: UIImage.programPlaceholder)
                typeImageView.backgroundColor = .clear
            }
        }
        
        if let details = model.externalTransactionDetails {
            if let fromAddress = details.fromAddress {
                titleLabel.text = fromAddress
                subtitleLabel.text = "From external address"
            }
            
            typeImageView.image = UIImage.programPlaceholder
            if let logo = details.fromAddress, let fileUrl = getFileURL(fileName: logo) {
                typeImageView.kf.indicatorType = .activity
                typeImageView.kf.setImage(with: fileUrl, placeholder: UIImage.programPlaceholder)
                typeImageView.backgroundColor = .clear
            }
        }
        
        firstTitleLabel.text = "Amount"
        if let amount = model.amount, let currency = model.currency, let currencyType = CurrencyType(rawValue: currency.rawValue) {
            firstValueLabel.text = amount.rounded(withType: currencyType).toString() + " " + currencyType.rawValue
        }
        
        secondTitleLabel.text = "Status"
        if let status = model.status {
            secondValueLabel.text = status.rawValue
        }
    }
    
    // MARK: - Actions
    @IBAction func copyAddressButtonAction(_ sender: UIButton) {
        delegate?.copyAddressButtonDidPress()
    }
    
    @IBAction func copyHashButtonAction(_ sender: UIButton) {
        delegate?.copyHashButtonDidPress()
    }
}
