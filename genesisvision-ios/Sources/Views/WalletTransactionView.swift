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
    @IBOutlet var typeImageView: UIImageView! {
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
    func configure(_ model: WalletTransaction) {
        if let information = model.information {
            titleLabel.text = information
        }
        
        typeImageView.image = nil
        
        if let action = model.action, let sourceType = model.sourceType, let destinationType = model.destinationType, let value = model.amount {
            var sign = ""
            
            switch action {
            case .transfer:
                if sourceType == .paymentTransaction, action == .transfer, destinationType == .wallet {
                    typeImageView.image = #imageLiteral(resourceName: "img_entry_arrow_down")
                    sign = "+"
                }
                
                if sourceType == .wallet, action == .transfer, destinationType == .withdrawalRequest {
                    typeImageView.image = #imageLiteral(resourceName: "img_entry_arrow_up")
                    sign = "-"
                }
                
                if sourceType == .withdrawalRequest, action == .transfer, destinationType == .paymentTransaction {
                    typeImageView.image = #imageLiteral(resourceName: "img_entry_arrow_up")
                    sign = "-"
                }
            default:
                if sourceType == .wallet {
                    typeImageView.image = #imageLiteral(resourceName: "img_entry_arrow_up")
                    sign = "-"
                } else if destinationType == .wallet {
                    typeImageView.image = #imageLiteral(resourceName: "img_entry_arrow_down")
                    sign = "+"
                }
            }
            
            subtitleLabel.text = sign + value.rounded(withType: .gvt).toString() + " \(Constants.gvtString)"
        }
        
        firstTitleLabel.text = "Withdraw currency"
        if let sourceCurrency = model.sourceCurrency {
            firstValueLabel.text = sourceCurrency.rawValue
        }
        
        secondTitleLabel.text = "To address"
        if let wallet = model.destinationWithdrawalInfo?.wallet {
            secondValueLabel.text = wallet
        }
        
        
        thirdTitleLabel.text = "To address"
        if let hash = model.destinationBlockchainInfo?.hash {
            thirdValueLabel.text = hash
        }
        
        fourthTitleLabel.text = "Date"
        if let date = model.date {
            fourthValueLabel.text = date.dateAndTimeFormatString
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
