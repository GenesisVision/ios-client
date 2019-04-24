//
//  AboutLevelView.swift
//  genesisvision-ios
//
//  Created by George on 10/12/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

protocol AboutLevelViewProtocol: class {
    func aboutLevelsButtonDidPress()
}

class AboutLevelView: UIView {
    // MARK: - Variables
    weak var delegate: AboutLevelViewProtocol?
    
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: TitleLabel! {
        didSet {
            titleLabel.font = UIFont.getFont(.semibold, size: 18.0)
            titleLabel.textColor = UIColor.primary
        }
    }
    
    @IBOutlet weak var firstTitleLabel: SubtitleLabel! {
        didSet {
            firstTitleLabel.font = UIFont.getFont(.regular, size: 12.0)
            firstTitleLabel.text = "Level Up:"
        }
    }
    @IBOutlet weak var firstValueLabel: TitleLabel! {
        didSet {
            firstValueLabel.font = UIFont.getFont(.semibold, size: 14.0)
        }
    }
    @IBOutlet weak var firstStackView: UIStackView! {
        didSet {
            firstStackView.isHidden = false
        }
    }
    
    @IBOutlet weak var secondTitleLabel: SubtitleLabel! {
        didSet {
            secondTitleLabel.font = UIFont.getFont(.regular, size: 12.0)
            secondTitleLabel.text = "Invest limit:"
        }
    }
    @IBOutlet weak var secondValueLabel: TitleLabel! {
        didSet {
            secondValueLabel.font = UIFont.getFont(.semibold, size: 14.0)
        }
    }
    @IBOutlet weak var secondStackView: UIStackView! {
        didSet {
            secondStackView.isHidden = false
        }
    }

    @IBOutlet weak var disclaimerLabel: SubtitleLabel! {
        didSet {
            disclaimerLabel.text = "Genesis level shows the experience and reliability of the Manager"
            
            disclaimerLabel.setLineSpacing(lineSpacing: 3.0)
        }
    }
    
    @IBOutlet weak var aboutLevelsButton: ActionButton! {
        didSet {
            aboutLevelsButton.setTitle("About Levels", for: .normal)
        }
    }

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.Cell.bg
    }
    
    // MARK: - Public Methods
    func configure(_ programDetailsRating: ProgramDetailsRating?, level: Int?, currency: PlatformAPI.Currency_v10PlatformLevelsGet) {
        guard let programDetailsRating = programDetailsRating, let level = level else { return }
        
        titleLabel.text = "Genesis Level \(level)"
        
        if let canLevelUp = programDetailsRating.canLevelUp, canLevelUp {
            firstValueLabel.text = "Top 10%"
        } else {
            firstStackView.isHidden = true
        }
        
        showProgressHUD()
        PlatformManager.shared.getProgramsLevelsInfo(currency) { [weak self] (programsLevelsInfo) in
            self?.hideHUD()
            
            guard let levelsInfo = programsLevelsInfo, let levels = levelsInfo.levels else { return }
            
            if let levelInfo = levels.first(where: {$0.level == level}), let investmentLimit = levelInfo.investmentLimit {
                self?.secondValueLabel.text = investmentLimit.toString() + " " + currency.rawValue
            } else {
                self?.secondStackView.isHidden = true
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func aboutLevelsButtonAction(_ sender: UIButton) {
        delegate?.aboutLevelsButtonDidPress()
    }
}
