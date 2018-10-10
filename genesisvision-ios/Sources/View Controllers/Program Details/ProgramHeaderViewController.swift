//
//  ProgramHeaderViewController.swift
//  genesisvision-ios
//
//  Created by George on 28/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Kingfisher

class ProgramHeaderViewController: BaseViewController {
    
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
    
    @IBOutlet weak var hederTitleImageView: UIImageView! {
        didSet {
            hederTitleImageView.alpha = 0.0
            hederTitleImageView.roundCorners(with: 6.0)
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
    @IBOutlet weak var tagsStackView: UIStackView!
    
    @IBOutlet weak var levelButton: LevelButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var currencyLabel: CurrencyLabel!
    
    @IBOutlet var tagsLabel: [UILabel]!
    
    @IBOutlet weak var labelsLeadingConstraint: NSLayoutConstraint!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.Cell.bg
    }
    
    
    // MARK: - Public methods
    func moveLabels(offset: CGFloat) {
        self.labelsLeadingConstraint.constant = 16.0 + offset
        
        if self.labelsLeadingConstraint.constant > 80.0 {
            self.labelsLeadingConstraint.constant = 80.0
        }
    }
    
    func changeColorAlpha(offset: CGFloat) {
        print("changeColorAlpha")
        print(offset)
        self.levelButton.alpha = 1.0 - offset
        self.bgImageView.alpha = 1.0 - offset
        self.currencyLabel.alpha = 1.0 - offset * 2
        self.investedImageView.alpha = 1.0 - offset * 2
        
        self.hederTitleImageView.alpha = offset
        
        self.titleLeadingConstraint.constant = 16.0 + offset * 50.0
        self.titleBottomConstraint.constant = 20.0 - offset * 50.0

        gradientView.backgroundColor = UIColor.Cell.bg.withAlphaComponent(offset)
    }
    
    func configure(_ programDetailsFull: ProgramDetailsFull?) {
        if let title = programDetailsFull?.title {
            titleLabel.text = title
        }
        
        if let currency = programDetailsFull?.currency {
            currencyLabel.text = currency.rawValue
        }
        
        bgImageView.image = UIImage.placeholder
        
        if let logo = programDetailsFull?.logo, let fileUrl = getFileURL(fileName: logo) {
            bgImageView.kf.indicatorType = .activity
            hederTitleImageView.kf.indicatorType = .activity
            
            let resource = ImageResource(downloadURL: fileUrl, cacheKey: "my_cache_key")
            bgImageView.kf.setImage(with: resource, placeholder: UIImage.placeholder)
            hederTitleImageView.kf.setImage(with: resource, placeholder: UIImage.placeholder)
        }
        
        if let isInvested = programDetailsFull?.personalProgramDetails?.isInvested {
            self.investedImageView.isHidden = !isInvested
        }
    }
}
