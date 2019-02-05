//
//  AboutLevelsViewController.swift
//  genesisvision-ios
//
//  Created by George on 06/12/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class LevelStackView: UIStackView {
    @IBOutlet weak var levelButton: LevelButton!
    @IBOutlet weak var valueLabel: TitleLabel!
}

class AboutLevelsViewController: BaseViewController {
    
    // MARK: - Buttons
    @IBOutlet weak var titleLabel: TitleLabel! {
        didSet {
            titleLabel.font = UIFont.getFont(.semibold, size: 18.0)
        }
    }
    
    @IBOutlet weak var textLabel: SubtitleLabel! {
        didSet {
            textLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    
    @IBOutlet weak var levelsTitleLabel: TitleLabel! {
        didSet {
            levelsTitleLabel.font = UIFont.getFont(.semibold, size: 18.0)
        }
    }
    
    @IBOutlet weak var levelsView: UIView! {
        didSet {
            levelsView.roundCorners(with: Constants.SystemSizes.cornerSize)
            levelsView.backgroundColor = UIColor.Cell.bg
        }
    }
    
    @IBOutlet var levelStackViews: [LevelStackView]!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showProgressHUD()
        setupUI()
    }
    
    // MARK: - Private methods
    private func setupUI() {
        title = "About levels"
        
        titleLabel.text = "Basic rules of levelling up"
        
        let text = "1. All of the managers are levelled up only on the first day of each month.\n\n2. A manager can go up only one level at a time.\n\n3. In order to level-up, you need to end up in the top 10% of investment programs ranked by profit among all of the other competing programs of the same level.\n\n4. Profit is calculated as a percentage and is calculated over a certain period. The general rule of thumb is that the period of time is calculated as “managers’ level — 1 month”. \nFor example: if your current level is 4, then the last three months of your trading will be counted.\n\n5. All programs that have completed at least one trade participate in the rating.\n\n6. Each level needs to have a minimum of ten participators. You can’t level up if fewer than ten people are competing against you.\n\n7. The higher a manager’s level is — the more funds he can attract.\n\n\nThat’s it, those are all the rules! Here is a simplified recap: you need to end up in the top 10% of the most profitable managers that have the same level as you. Oh, and we almost forgot! We bet that you wish to know the amounts of GVT that can be attracted on each level. \n\nWorry not, there they are:"
        
        textLabel.text = text
        textLabel.setLineSpacing(lineSpacing: 3.0)
        
        levelsTitleLabel.text = "Levels limit"
        
        PlatformManager.shared.getProgramsLevelsInfo { [weak self] (programsLevelsInfo) in
            self?.hideAll()
            
            guard let levelsInfo = programsLevelsInfo, let levels = levelsInfo.levels else { return }
            
            for levelInfo in levels {
                guard let level = levelInfo.level, let investmentLimit = levelInfo.investmentLimit, let levelStackView = self?.levelStackViews[level - 1] else { return }
                
                levelStackView.levelButton.setTitle(level.toString(), for: .normal)
                levelStackView.valueLabel.text = investmentLimit.toString() + " GVT"
            }
        }
    }
}

extension UILabel {
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
        guard let labelText = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        
        let attributedString: NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
}
