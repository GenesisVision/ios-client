//
//  SocialEventView.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 18.02.2021.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit

class SocialEventView: UIView {
    
    private let mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let eventImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleToFill
        imageView.maskToBounds = true
        return imageView
    }()
    
    private let assetImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleToFill
        imageView.maskToBounds = true
        return imageView
    }()
    
    private let eventTitleLabel: TitleLabel = {
        let label = TitleLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.getFont(.semibold, size: 14.0)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        return label
    }()
    
    private let eventAmountLabel: TitleLabel = {
        let label = TitleLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.getFont(.semibold, size: 14.0)
        label.textAlignment = .right
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        assetImageView.roundCorners()
    }
    
    func configure(event: PostEvent, assetDetails: PostAssetDetailsWithPrices) {
        if let logo = event.logoUrl, let fileUrl = getFileURL(fileName: logo) {
            eventImageView.kf.indicatorType = .activity
            eventImageView.kf.setImage(with: fileUrl)
        }
        
        if let logoUrl = assetDetails.logoUrl, let fileUrl = getFileURL(fileName: logoUrl) {
            assetImageView.kf.indicatorType = .activity
            assetImageView.kf.setImage(with: fileUrl)
        } else if let color = assetDetails.color {
            assetImageView.image = UIImage.programPlaceholder
            assetImageView.backgroundColor = UIColor.hexColor(color)
        }
        
        if let title = event.title {
            eventTitleLabel.text = title
        }
        
        if let amount = event.amount?.toString(), let currency = event.currency {
            eventAmountLabel.text = amount + " " + currency.rawValue
        }
        
        assetImageView.roundCorners()
        layoutIfNeeded()
    }
    
    
    private func setup() {
        addSubview(mainView)
        mainView.fillSuperview(padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        
        mainView.addSubview(eventImageView)
        mainView.addSubview(assetImageView)
        mainView.addSubview(eventTitleLabel)
        mainView.addSubview(eventAmountLabel)
        
        
        
        eventImageView.anchorSize(size: CGSize(width: 25, height: 25))
        assetImageView.anchorSize(size: CGSize(width: 25, height: 25))
        
        assetImageView.anchor(top: mainView.topAnchor,
                              leading: mainView.leadingAnchor,
                              bottom: nil, trailing: nil)
        eventImageView.anchor(top: nil,
                              leading: assetImageView.leadingAnchor,
                              bottom: mainView.bottomAnchor, trailing: nil,
                              padding: UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 0))
        
        
//        eventImageView.anchor(top: nil, leading: mainView.leadingAnchor, bottom: nil, trailing: nil)
//        eventImageView.anchorCenter(centerY: mainView.centerYAnchor, centerX: nil)
        
        eventTitleLabel.anchor(top: mainView.topAnchor,
                               leading: eventImageView.trailingAnchor,
                               bottom: mainView.bottomAnchor, trailing: eventAmountLabel.leadingAnchor,
                               padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10),
                               size: CGSize(width: 150, height: 0))
        
        eventAmountLabel.anchor(top: mainView.topAnchor,
                                leading: eventTitleLabel.trailingAnchor,
                                bottom: mainView.bottomAnchor,
                                trailing: mainView.trailingAnchor,
                                padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
    }
}
