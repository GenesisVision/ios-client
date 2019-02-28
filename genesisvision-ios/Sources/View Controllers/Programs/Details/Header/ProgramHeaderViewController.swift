//
//  ProgramHeaderViewController.swift
//  genesisvision-ios
//
//  Created by George on 28/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Kingfisher

protocol ProgramHeaderViewControllerProtocol: class {
    func aboutLevelButtonDidPress()
}

class ProgramHeaderViewController: BaseViewController {
    // MARK: - Variables
    weak var delegate: ProgramHeaderViewControllerProtocol?
    
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
            titleTrailingConstraint.constant = 0.0
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
    @IBOutlet weak var levelBgImageView: UIImageView!
    @IBOutlet weak var levelButton: LevelButton! {
        didSet {
            levelButton.borderSize = 0.0
        }
    }
    
    @IBOutlet weak var titleLabel: TitleLabel! {
        didSet {
            titleLabel.font = UIFont.getFont(.semibold, size: 26.0)
        }
    }
    
    @IBOutlet weak var tagsView: UIScrollView!
    @IBOutlet weak var currencyLabel: CurrencyLabel!
    @IBOutlet weak var ratingTagLabel: RoundedLabel! {
        didSet {
            ratingTagLabel.isHidden = true
            ratingTagLabel.text = "TOP 10%"
            ratingTagLabel.textColor = UIColor.Cell.ratingTagTitle
            ratingTagLabel.backgroundColor = UIColor.Cell.ratingTagBg
        }
    }
    
    @IBOutlet weak var firstTagLabel: RoundedLabel! {
        didSet {
            firstTagLabel.isHidden = true
        }
    }
    @IBOutlet weak var secondTagLabel: RoundedLabel! {
        didSet {
            secondTagLabel.isHidden = true
        }
    }
    @IBOutlet weak var thirdTagLabel: RoundedLabel! {
        didSet {
            thirdTagLabel.isHidden = true
        }
    }
    @IBOutlet weak var fourthTagLabel: RoundedLabel! {
        didSet {
            fourthTagLabel.isHidden = true
        }
    }
    
    @IBOutlet weak var labelsLeadingConstraint: NSLayoutConstraint!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.Cell.bg
        activityIndicator.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.levelButton.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }, completion: { _ in
            UIView.animate(withDuration: 0.3, animations: {
                self.levelButton.transform = CGAffineTransform.identity
            }, completion: { _ in
                self.levelButton.layoutSubviews()
            })
        })
    }
    
    // MARK: - Public methods
    func moveLabels(offset: CGFloat) {
        self.labelsLeadingConstraint.constant = 16.0 + offset
        
        if self.labelsLeadingConstraint.constant > 80.0 {
            self.labelsLeadingConstraint.constant = 80.0
        }
    }
    
    func changeColorAlpha(offset: CGFloat) {
        self.levelBgImageView.alpha = 1.0 - offset
        self.levelButton.alpha = 1.0 - offset
        self.bgImageView.alpha = 1.0 - offset
        self.tagsView.alpha = 1.0 - offset * 2
        
        self.investedImageView.alpha = 1.0 - offset * 2
        
        self.headerTitleImageView.alpha = offset
        
        self.titleLeadingConstraint.constant = 16.0 + offset * 50.0
        self.titleBottomConstraint.constant = 20.0 - offset * 46.0
        self.titleTrailingConstraint.constant = offset * 76.0
        
        self.titleLabel.font = UIFont.getFont(.semibold, size: 26.0 - 10.0 * offset)
        
        gradientView.backgroundColor = UIColor.Cell.bg.withAlphaComponent(offset)
    }
    
    func configure(_ programDetailsFull: ProgramDetailsFull?) {
        setupTags(programDetailsFull)
        
        if let title = programDetailsFull?.title {
            titleLabel.text = title
        }
        
        if let currency = programDetailsFull?.currency {
            currencyLabel.text = currency.rawValue
        }
        
        if let level = programDetailsFull?.level {
            levelButton.setTitle(level.toString(), for: .normal)
        }
        
        bgImageView.image = UIImage.programPlaceholder
        headerTitleImageView.image = UIImage.programPlaceholder
        
        if let color = programDetailsFull?.color {
            bgImageView.backgroundColor = UIColor.hexColor(color)
            headerTitleImageView.backgroundColor = UIColor.hexColor(color)
        }
        
        if let logo = programDetailsFull?.logo, let fileUrl = getFileURL(fileName: logo) {
            bgImageView.kf.indicatorType = .activity
            headerTitleImageView.kf.indicatorType = .activity
            
            let resource = ImageResource(downloadURL: fileUrl, cacheKey: logo)
            bgImageView.kf.setImage(with: resource, placeholder: UIImage.programPlaceholder)
            headerTitleImageView.kf.setImage(with: resource, placeholder: UIImage.programPlaceholder)
        }
        
        if let isInvested = programDetailsFull?.personalProgramDetails?.isInvested {
            self.investedImageView.isHidden = !isInvested
        }
        
        if let rating = programDetailsFull?.rating, let canLevelUp = rating.canLevelUp {
            ratingTagLabel.isHidden = !canLevelUp
        }
    }
    
    func setupTags(_ programDetailsFull: ProgramDetailsFull?) {
        guard let programDetailsFull = programDetailsFull, let tags = programDetailsFull.tags, !tags.isEmpty else { return }
        
        let tagsCount = tags.count
        
        firstTagLabel.isHidden = true
        if let name = tags[0].name, let color = tags[0].color {
            firstTagLabel.isHidden = false
            firstTagLabel.text = name.uppercased()
            firstTagLabel.backgroundColor = UIColor.hexColor(color).withAlphaComponent(0.1)
            firstTagLabel.textColor = UIColor.hexColor(color)
        }
        
        secondTagLabel.isHidden = true
        if tagsCount > 1, let name = tags[1].name, let color = tags[1].color {
            secondTagLabel.isHidden = false
            secondTagLabel.text = name.uppercased()
            secondTagLabel.backgroundColor = UIColor.hexColor(color).withAlphaComponent(0.1)
            secondTagLabel.textColor = UIColor.hexColor(color)
        }
        
        thirdTagLabel.isHidden = true
        if tagsCount > 2, let name = tags[2].name, let color = tags[2].color {
            thirdTagLabel.isHidden = false
            thirdTagLabel.text = name.uppercased()
            thirdTagLabel.backgroundColor = UIColor.hexColor(color).withAlphaComponent(0.1)
            thirdTagLabel.textColor = UIColor.hexColor(color)
        }
        
        fourthTagLabel.isHidden = true
        if tagsCount > 3, let name = tags[3].name, let color = tags[3].color {
            fourthTagLabel.isHidden = false
            fourthTagLabel.text = name.uppercased()
            fourthTagLabel.backgroundColor = UIColor.hexColor(color).withAlphaComponent(0.1)
            fourthTagLabel.textColor = UIColor.hexColor(color)
        }
    }
    
    // MARK: - Actions
    @IBAction func aboutLevelButtonAction(_ sender: UIButton) {
        delegate?.aboutLevelButtonDidPress()
    }
}
