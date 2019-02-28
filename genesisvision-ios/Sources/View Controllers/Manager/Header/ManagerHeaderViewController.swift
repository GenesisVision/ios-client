//
//  ManagerHeaderViewController.swift
//  genesisvision-ios
//
//  Created by George on 17/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Kingfisher

class ManagerHeaderViewController: BaseViewController {
    
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
            headerTitleImageView.roundCorners()
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
    @IBOutlet weak var subtitleLabel: SubtitleLabel! {
        didSet {
            subtitleLabel.font = UIFont.getFont(.regular, size: 14.0)
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
        self.subtitleLabel.alpha = 1.0 - offset * 2
        
        self.headerTitleImageView.alpha = offset
        
        self.titleLeadingConstraint.constant = 16.0 + offset * 50.0
        self.titleBottomConstraint.constant = 20.0 - offset * 50.0
        self.titleTrailingConstraint.constant = 16.0 + offset * 76.0
        
        gradientView.backgroundColor = UIColor.Cell.bg.withAlphaComponent(offset)
    }
    
    func configure(_ managerProfileDetails: ManagerProfileDetails?) {
        if let username = managerProfileDetails?.managerProfile?.username {
            titleLabel.text = username
        }
        
        if let regDate = managerProfileDetails?.managerProfile?.regDate {
            subtitleLabel.text = "Member since " + regDate.onlyDateFormatString
        }
        
        bgImageView.image = UIImage.profilePlaceholder
        headerTitleImageView.image = UIImage.profilePlaceholder
        
        if let logo = managerProfileDetails?.managerProfile?.avatar, let fileUrl = getFileURL(fileName: logo) {
            bgImageView.kf.indicatorType = .activity
            headerTitleImageView.kf.indicatorType = .activity
            
            let resource = ImageResource(downloadURL: fileUrl, cacheKey: logo)
            bgImageView.kf.setImage(with: resource, placeholder: UIImage.profilePlaceholder)
            headerTitleImageView.kf.setImage(with: resource, placeholder: UIImage.profilePlaceholder)
        }
    }
}

