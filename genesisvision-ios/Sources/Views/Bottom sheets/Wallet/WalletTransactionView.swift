//
//  WalletTransactionView.swift
//  genesisvision-ios
//
//  Created by George on 26/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

protocol WalletTransactionViewProtocol: class {
    func closeButtonDidPress()
    func openUrlButtonDidPress(_ url: String)
    func copyAddressButtonDidPress(_ address: String)
    func openAssetDidPress(_ assetId: String, assetType: AssetType)
    func resendButtonDidPress(_ uuid: UUID)
    func cancelButtonDidPress(_ uuid: UUID)
}

class WalletTransactionView: UIView {
    // MARK: - Variables
    weak var delegate: WalletTransactionViewProtocol?
    
    var uuid: UUID?
    var transactionDetails: TransactionViewModel?
    
    // MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topStackView: TopStackView!

    @IBOutlet weak var assetStackView: AssetStackView! {
        didSet {
            assetStackView.isHidden = true
        }
    }
    @IBOutlet weak var amountStackView: AmountStackView! {
        didSet {
            amountStackView.isHidden = true
        }
    }
    @IBOutlet weak var detailsStackView: UIStackView! {
        didSet {
            detailsStackView.isHidden = true
        }
    }
    @IBOutlet weak var statusStackView: StatusStackView! {
        didSet {
            statusStackView.isHidden = true
        }
    }
    @IBOutlet weak var actionsStackView: ActionsStackView! {
        didSet {
            actionsStackView.isHidden = true
        }
    }
    @IBOutlet weak var externalStackView: ExternalStackView! {
        didSet {
            externalStackView.isHidden = true
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.Cell.bg
    }
    
    // MARK: - Public Methods
    func configure(_ model: TransactionViewModel) {
        self.scrollView.contentInset.bottom = 40.0
        self.uuid = model.id
        self.transactionDetails = model
        
        setup(model)
    }
    
    // MARK: - Actions
    @IBAction func copyAddressButtonAction(_ sender: UIButton) {
        if let fromAddress = externalStackView.titleLabel.text {
            delegate?.copyAddressButtonDidPress(fromAddress)
        }
    }
    @IBAction func openUrlButtonAction(_ sender: UIButton) {
        if let url = externalStackView.urlButton.titleLabel?.text {
            delegate?.openUrlButtonDidPress(url)
        }
    }
    @IBAction func closeButtonAction(_ sender: UIButton) {
        delegate?.closeButtonDidPress()
    }
    
    @IBAction func resendButtonAction(_ sender: UIButton) {
        if let uuid = uuid {
            delegate?.resendButtonDidPress(uuid)
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        if let uuid = uuid {
            delegate?.cancelButtonDidPress(uuid)
        }
    }
    
    @IBAction func openAssetAction(_ sender: UIButton) {
        if let assetId = transactionDetails?.asset?.id?.uuidString, let assetType = transactionDetails?.asset?.assetType {
            delegate?.openAssetDidPress(assetId, assetType: assetType)
        }
    }
}

// MARK: - Setups
extension WalletTransactionView {
    private func setup(_ model: TransactionViewModel) {
        topStackView.titleLabel.text = "Transaction details"
        
        if let detailsTitle = model.detailsTitle {
            topStackView.subtitleLabel.isHidden = false
            topStackView.subtitleLabel.text = detailsTitle
        } else {
            topStackView.subtitleLabel.isHidden = true
        }
        
        if let asset = model.asset {
            assetStackView.isHidden = false
            if let description = asset.description {
                assetStackView.headerLabel.text = description
            }
            assetStackView.assetLogoImageView?.profilePhotoImageView.image = UIImage.programPlaceholder
            if let color = asset.color {
                assetStackView.assetLogoImageView?.profilePhotoImageView?.backgroundColor = UIColor.hexColor(color)
            }
            if let logo = asset.logo, let fileUrl = getFileURL(fileName: logo) {
                assetStackView.assetLogoImageView?.profilePhotoImageView.kf.indicatorType = .activity
                assetStackView.assetLogoImageView?.profilePhotoImageView.kf.setImage(with: fileUrl, placeholder: UIImage.programPlaceholder)
                assetStackView.assetLogoImageView?.profilePhotoImageView.backgroundColor = .clear
            }

            if let program = asset.programDetails, let level = program.level, let levelProgress = program.levelProgress { assetStackView.assetLogoImageView.levelButton.setTitle(level.toString(), for: .normal)
                assetStackView.assetLogoImageView.levelButton.progress = levelProgress
            } else {
                assetStackView.assetLogoImageView.levelButton.isHidden = true
            }

            if let title = asset.title {
                assetStackView.titleLabel.text = title
            }

            if let managerName = asset.manager {
                assetStackView.subtitleLabel.text = managerName
            }
            
            assetStackView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openAssetAction(_:)))
            tapGesture.numberOfTapsRequired = 1
            assetStackView.addGestureRecognizer(tapGesture)
        } else {
            assetStackView.isHidden = true
        }
        
        if let amount = model.amount {
            amountStackView.isHidden = false
            amountStackView.headerLabel.text = amount.title ?? "Wallet"
            
            if let amount = amount.first {
                amountStackView.firstStackView.isHidden = false
                if let currency = amount.currency?.rawValue {
                    amountStackView.firstStackView.titleLabel.text = currency
                }
                
                if let logo = amount.logo, let fileUrl = getFileURL(fileName: logo) {
                    amountStackView.firstStackView.iconImageView.kf.indicatorType = .activity
                    amountStackView.firstStackView.iconImageView.kf.setImage(with: fileUrl, placeholder: UIImage.walletPlaceholder)
                    amountStackView.firstStackView.iconImageView.backgroundColor = .clear
                }
            } else {
                amountStackView.firstStackView.isHidden = true
            }

            if let amount = amount.second {
                amountStackView.secondStackView.isHidden = false
                amountStackView.secondStackView.convertImageView.isHidden = false
                
                if let currency = amount.currency?.rawValue {
                    amountStackView.secondStackView.titleLabel.text = currency
                }
                
                if let logo = amount.logo, let fileUrl = getFileURL(fileName: logo) {
                    amountStackView.secondStackView.iconImageView.kf.indicatorType = .activity
                    amountStackView.secondStackView.iconImageView.kf.setImage(with: fileUrl, placeholder: UIImage.walletPlaceholder)
                    amountStackView.secondStackView.iconImageView.backgroundColor = .clear
                }
            } else {
                amountStackView.secondStackView.isHidden = true
            }
        } else {
            amountStackView.isHidden = true
        }
        
        if let details = model.details {
            detailsStackView.isHidden = false
    
            detailsStackView.removeAllArrangedSubviews()
            
            details.forEach { (model) in
                if let url = model.url {
                    externalStackView.isHidden = false
                    externalStackView.titleLabel.isHidden = true
                    externalStackView.urlButton.isHidden = false
                    
                    externalStackView.headerLabel.text = model.title ?? ""
                    externalStackView.urlButton.setTitle(url, for: .normal)
                    
                    return
                }
                
                if let canCopy = model.canCopy, canCopy {
                    externalStackView.isHidden = false
                    externalStackView.titleLabel.isHidden = false
                    externalStackView.copyButton.isHidden = false
                    
                    externalStackView.headerLabel.text = model.title ?? ""
                    externalStackView.titleLabel.text = model.details ?? ""
                    
                    return
                }
                
                let headerLabel = SubtitleLabel()
                headerLabel.font = UIFont.getFont(.semibold, size: 12.0)
                headerLabel.text = model.title ?? ""
                
                let titleLabel = TitleLabel()
                titleLabel.font = UIFont.getFont(.regular, size: 16.0)
                titleLabel.text = model.details ?? ""
                
                let vStack = UIStackView(arrangedSubviews: [headerLabel, titleLabel])
                vStack.axis = .vertical
                vStack.spacing = 12.0
                vStack.alignment = .fill
                vStack.distribution = .fillProportionally

                detailsStackView.addArrangedSubview(vStack)
            }
        } else {
            detailsStackView.isHidden = true
        }
        
        if let actions = model.actions {
            actionsStackView.isHidden = false
            if let canCancel = actions.canCancel {
                actionsStackView.cancelButton.isHidden = !canCancel
            }
            if let canResend = actions.canResend {
                actionsStackView.resendButton.isHidden = !canResend
            }
        } else {
            actionsStackView.isHidden = true
        }
        
        if let status = model.status {
            statusStackView.isHidden = false
            
            var image = #imageLiteral(resourceName: "img_wallet_status_pending_icon")
            switch status {
            case .done:
                image = #imageLiteral(resourceName: "img_wallet_status_done_icon")
            case .canceled, .error:
                image = #imageLiteral(resourceName: "img_wallet_status_delete_icon")
            case .pending:
                image = #imageLiteral(resourceName: "img_wallet_status_pending_icon")
            }
            
            statusStackView.iconImageView.image = image
            statusStackView.headerLabel.text = "Status"
            statusStackView.titleLabel.text = status.rawValue
        } else {
            statusStackView.isHidden = true
        }
    }
}

class TopStackView: UIStackView {
    @IBOutlet weak var iconImageView: UIImageView! {
        didSet {
            iconImageView.contentMode = .scaleAspectFit
            iconImageView.clipsToBounds = true
            iconImageView.image = UIImage.eventPlaceholder
            iconImageView.roundCorners()
        }
    }
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleLabel: TitleLabel! {
        didSet {
            titleLabel.font = UIFont.getFont(.semibold, size: 18.0)
        }
    }
    
    @IBOutlet weak var subtitleLabel: TitleLabel! {
        didSet {
            subtitleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
}

class DefaultStackView: UIStackView {
    @IBOutlet weak var headerLabel: SubtitleLabel! {
        didSet {
            headerLabel.font = UIFont.getFont(.semibold, size: 12.0)
        }
    }
    @IBOutlet weak var titleLabel: TitleLabel! {
        didSet {
            titleLabel.font = UIFont.getFont(.regular, size: 16.0)
        }
    }
    @IBOutlet weak var subtitleLabel: SubtitleLabel! {
        didSet {
            subtitleLabel.font = UIFont.getFont(.semibold, size: 12.0)
        }
    }
}


class StatusStackView: DefaultStackView {
    @IBOutlet weak var iconImageView: UIImageView! {
        didSet {
            iconImageView.roundCorners()
        }
    }
}

class WalletStackView: UIStackView {
    @IBOutlet weak var convertImageView: UIImageView! {
        didSet {
            convertImageView.image = #imageLiteral(resourceName: "img_event_withdraw")
            convertImageView.isHidden = true
        }
    }
    @IBOutlet weak var iconImageView: UIImageView! {
        didSet {
            iconImageView.roundCorners()
        }
    }
    @IBOutlet weak var titleLabel: TitleLabel! {
        didSet {
            titleLabel.font = UIFont.getFont(.regular, size: 16.0)
        }
    }
}

class AmountStackView: UIStackView {
    @IBOutlet weak var headerLabel: SubtitleLabel! {
        didSet {
            headerLabel.font = UIFont.getFont(.semibold, size: 12.0)
        }
    }
    
    @IBOutlet weak var firstStackView: WalletStackView!
    @IBOutlet weak var secondStackView: WalletStackView! {
        didSet {
            secondStackView.isHidden = true
        }
    }
}

class ActionsStackView: UIStackView {
    @IBOutlet weak var resendButton: ActionButton! {
        didSet {
            resendButton.setTitle("Resend email", for: .normal)
        }
    }
    @IBOutlet weak var cancelButton: ActionButton! {
        didSet {
            cancelButton.setTitle("Cancel", for: .normal)
            cancelButton.configure(with: .highClear)
        }
    }
}

class AssetStackView: DefaultStackView {
    @IBOutlet weak var assetLogoImageView: ProfileImageView!
}

class ExternalStackView: DefaultStackView {
    @IBOutlet weak var urlButton: ActionButton! {
        didSet {
            urlButton.configure(with: .lightBorder)
            urlButton.isHidden = true
        }
    }
    
    @IBOutlet weak var copyButton: ActionButton! {
        didSet {
            copyButton.configure(with: .lightBorder)
            copyButton.isHidden = true
        }
    }
}
