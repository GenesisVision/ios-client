//
//  FundHeaderViewController.swift
//  genesisvision-ios
//
//  Created by George on 25/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Kingfisher

class FundHeaderViewController: BaseViewController {
    
    @IBOutlet weak var activityIndicatorTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var titleBottomConstraint: NSLayoutConstraint! {
        didSet {
            titleBottomConstraint.constant = 20.0
        }
    }
    @IBOutlet weak var titleLeadingConstraint: NSLayoutConstraint! {
        didSet {
            titleLeadingConstraint.constant = 16.0
        }
    }
    @IBOutlet weak var titleTrailingConstraint: NSLayoutConstraint! {
        didSet {
            titleTrailingConstraint.constant = 16.0
        }
    }
    
    @IBOutlet weak var headerTitleImageView: UIImageView! {
        didSet {
            headerTitleImageView.alpha = 0.0
            headerTitleImageView.roundCorners(with: 6.0)
        }
    }
    
    @IBOutlet weak var investedImageView: UIImageView! {
        didSet {
            self.investedImageView.isHidden = true
        }
    }
    
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var gradientView: GradientView! {
        didSet {
            gradientView.colors = [UIColor.Cell.bg.withAlphaComponent(0.0).cgColor, UIColor.Cell.bg.cgColor]
            gradientView.backgroundColor = UIColor.Cell.bg.withAlphaComponent(0.0)
        }
    }
    
    @IBOutlet weak var labelsStackView: UIStackView!
    
    @IBOutlet weak var titleLabel: TitleLabel! {
        didSet {
            titleLabel.font = UIFont.getFont(.semibold, size: 26.0)
        }
    }
    @IBOutlet weak var labelsLeadingConstraint: NSLayoutConstraint!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.Cell.bg
        activityIndicator.startAnimating()
    }
    
    // MARK: - Public methods
    func moveLabels(offset: CGFloat) {
        self.labelsLeadingConstraint.constant = 16.0 + offset
        
        if self.labelsLeadingConstraint.constant > 80.0 {
            self.labelsLeadingConstraint.constant = 80.0
        }
    }
    
    func changeColorAlpha(offset: CGFloat) {
        self.bgImageView.alpha = 1.0 - offset
        self.investedImageView.alpha = 1.0 - offset * 2
        
        self.headerTitleImageView.alpha = offset - 0.2
        
        self.titleLeadingConstraint.constant = 16.0 + offset * 50.0
        self.titleBottomConstraint.constant = 20.0 - offset * 10.0
        self.titleTrailingConstraint.constant = 16.0 + offset * 76.0
        
        self.titleLabel.font = UIFont.getFont(.semibold, size: 26.0 - 10.0 * offset)
        
        gradientView.backgroundColor = UIColor.Cell.bg.withAlphaComponent(offset)
    }
    
    func configure(_ fundDetailsFull: FundDetailsFull?) {
        if let title = fundDetailsFull?.title {
            titleLabel.text = title
        }
    
        bgImageView.image = UIImage.fundPlaceholder
        headerTitleImageView.image = UIImage.fundPlaceholder
        
        if let color = fundDetailsFull?.color {
            bgImageView.backgroundColor = UIColor.hexColor(color)
            headerTitleImageView.backgroundColor = UIColor.hexColor(color)
        }
        
        if let logo = fundDetailsFull?.logo, let fileUrl = getFileURL(fileName: logo) {
            bgImageView.kf.indicatorType = .activity
            headerTitleImageView.kf.indicatorType = .activity
            
            let resource = ImageResource(downloadURL: fileUrl, cacheKey: logo)
            bgImageView.kf.setImage(with: resource, placeholder: UIImage.fundPlaceholder)
            headerTitleImageView.kf.setImage(with: resource, placeholder: UIImage.fundPlaceholder)
        }
        
        if let isInvested = fundDetailsFull?.personalFundDetails?.isInvested {
            self.investedImageView.isHidden = !isInvested
        }
    }
}
