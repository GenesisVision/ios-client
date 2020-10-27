//
//  EventDetailsView.swift
//  genesisvision-ios
//
//  Created by George on 04/09/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

protocol EventDetailsViewProtocol: class {
    func showAssetButtonDidPress(_ assetId: String, assetType: AssetType)
    func closeButtonDidPress()
}

class EventDetailsView: UIView {
    // MARK: - Variables
    weak var delegate: EventDetailsViewProtocol?
    
    var event: InvestmentEventViewModel?
    
    // MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topStackView: TopStackView!
    @IBOutlet weak var assetStackView: AssetStackView! {
        didSet {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showAssetButtonAction(_:)))
            tapGesture.numberOfTapsRequired = 1
            assetStackView.addGestureRecognizer(tapGesture)
        }
    }
    @IBOutlet weak var infoStackView: UIStackView! {
        didSet {
            infoStackView.isHidden = true
        }
    }
    @IBOutlet weak var feesLineView: UIView! {
        didSet {
            feesLineView.isHidden = true
        }
    }
    @IBOutlet weak var feesStackView: UIStackView! {
        didSet {
            feesStackView.isHidden = true
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.Cell.bg
    }
    
    // MARK: - Public Methods
    func configure(_ event: InvestmentEventViewModel) {
        self.event = event
        
        topStackView.titleLabel.text = event.title
        topStackView.subtitleLabel.text = event.date?.dateAndTimeFormatString

        if let logo = event.logoUrl, let fileUrl = getFileURL(fileName: logo) {
            topStackView.iconImageView.kf.indicatorType = .activity
            topStackView.iconImageView.kf.setImage(with: fileUrl, placeholder: UIImage.eventPlaceholder)
            topStackView.iconImageView.backgroundColor = .clear
        }
        
        if let details = event.assetDetails {
            assetStackView.assetLogoImageView.levelButton.isHidden = true

            if let assetType = details.assetType {
                switch assetType {
                case .fund:
                    assetStackView.assetLogoImageView?.profilePhotoImageView.image = UIImage.fundPlaceholder
                default:
                    assetStackView.assetLogoImageView?.profilePhotoImageView.image = UIImage.programPlaceholder
                }
            }
            
            if let color = details.color {
                assetStackView.assetLogoImageView?.profilePhotoImageView?.backgroundColor = UIColor.hexColor(color)
            }
            if let logo = details.logoUrl, let fileUrl = getFileURL(fileName: logo) {
                assetStackView.assetLogoImageView?.profilePhotoImageView.kf.indicatorType = .activity
                assetStackView.assetLogoImageView?.profilePhotoImageView.kf.setImage(with: fileUrl, placeholder: UIImage.programPlaceholder)
                assetStackView.assetLogoImageView?.profilePhotoImageView.backgroundColor = .clear
            }
            
            if let title = details.title {
                assetStackView.titleLabel.text = title
            }
        }
        
        if let extendedInfo = event.extendedInfo, !extendedInfo.isEmpty {
            infoStackView.isHidden = false
            extendedInfo.forEach { (info) in
                guard let title = info.title, let amount = info.amount, let currency = info.currency, let currencyType = CurrencyType(rawValue: currency.rawValue) else { return }
                
                infoStackView.addArrangedSubview(addStackViews(title: title, amount: amount, currency: currencyType))
            }
        } else if let amount = event.amount, let currency = event.currency, let currencyType = CurrencyType(rawValue: currency.rawValue) {
            infoStackView.isHidden = false
            infoStackView.addArrangedSubview(addStackViews(title: "Balance", amount: amount, currency: currencyType))
        }
        
        if let feesInfo = event.feesInfo, !feesInfo.isEmpty {
            feesLineView.isHidden = false
            feesStackView.isHidden = false
            feesInfo.forEach { (info) in
                guard let title = info.title, let amount = info.amount, let currency = info.currency, let currencyType = CurrencyType(rawValue: currency.rawValue) else { return }
                
                feesStackView.addArrangedSubview(addStackViews(title: title, amount: amount, currency: currencyType))
            }
        }
    }
    
    private func addStackViews(title: String, amount: Double, currency: CurrencyType) -> UIStackView {
        let titleLabel = SubtitleLabel()
        titleLabel.font = UIFont.getFont(.regular, size: 16.0)
        titleLabel.text = title
        
        let amountLabel = TitleLabel()
        amountLabel.font = UIFont.getFont(.semibold, size: 16.0)
        amountLabel.text = amount.rounded(toPlaces: 8).toString()
        
        let currencyLabel = SubtitleLabel()
        currencyLabel.font = UIFont.getFont(.regular, size: 16.0)
        currencyLabel.text = currency.rawValue
        
        let hStack = UIStackView(arrangedSubviews: [amountLabel, currencyLabel])
        hStack.axis = .horizontal
        hStack.spacing = 8.0
        hStack.alignment = .fill
        hStack.distribution = .fillProportionally
        
        let vStack = UIStackView(arrangedSubviews: [hStack])
        vStack.axis = .vertical
        vStack.spacing = 0.0
        vStack.alignment = .leading
        vStack.distribution = .fill
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, vStack])
        stackView.axis = .horizontal
        stackView.spacing = 8.0
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        
        return stackView
    }
    
    // MARK: - Actions
    @IBAction func closeButtonAction(_ sender: UIButton) {
        delegate?.closeButtonDidPress()
    }
    
    @IBAction func showAssetButtonAction(_ sender: UIButton) {
        guard let assetId = event?.assetDetails?._id?.uuidString, let type = event?.assetDetails?.assetType else { return }
        var assetType: AssetType = .program
        switch type {
        case .fund:
            assetType = .fund
        default:
            assetType = .program
        }
        
        delegate?.showAssetButtonDidPress(assetId, assetType: assetType)
    }
}
