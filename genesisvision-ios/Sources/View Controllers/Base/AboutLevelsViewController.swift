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
    @IBOutlet weak var subtitleLabel: SubtitleLabel! {
        didSet {
            subtitleLabel.textColor = UIColor.Cell.title
            subtitleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    
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
    
    var currency: PlatformAPI.Currency_v10PlatformLevelsGet = .gvt
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showProgressHUD()
        setupUI()
    }
    
    // MARK: - Private methods
    private func setupUI() {
        title = "About levels"
        
        subtitleLabel.text = "Genesis level shows the experience and reliability of a manager.\n\nAll of the investment programs of a manager that have not passed KYC are stuck on the first level and can’t level up unless the manager passes the KYC procedure. Once the verification process is completed, the investment programs of a manager receive a second level."
        subtitleLabel.setLineSpacing(lineSpacing: 3.0)
        
        titleLabel.text = "Further levels are given according to the algorithm:"
        
        let text = "1. All managers are levelled up only on the first day of each month.\n\n2. A manager can only progress one level at a time.\n\n3. In order to level up, you need to end up in the top 10% of investment programs ranked by profit among all of the other competing programs of the same level.\n\n4. Profit is calculated as a percentage and is calculated over a certain period. The general rule of thumb is that the period of time is calculated as “managers’ level — 1 month”. For example: if your current level is 4, then the last three months of your trading will be counted.\n\n5. All programs that have completed at least one trade participate in the rating.\n\n6. Each level needs to have a minimum of ten participants. You can’t level up if fewer than ten people are competing against you.\n\n7. The higher a manager’s level is — the more funds he can attract."
        
        textLabel.text = text
        textLabel.setLineSpacing(lineSpacing: 3.0)
        
        levelsTitleLabel.text = "Levels limit"
        
        PlatformManager.shared.getProgramsLevelsInfo(currency) { [weak self] (programsLevelsInfo) in
            self?.hideAll()
            
            guard let levelsInfo = programsLevelsInfo, let levels = levelsInfo.levels else { return }
            
            for levelInfo in levels {
                guard let level = levelInfo.level, let investmentLimit = levelInfo.investmentLimit, let levelStackView = self?.levelStackViews[level - 1] else { return }
                
                levelStackView.levelButton.setTitle(level.toString(), for: .normal)
                levelStackView.valueLabel.text = investmentLimit.toString() + " "
                
                if let currency = self?.currency.rawValue {
                    levelStackView.valueLabel.text?.append(currency)
                }
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
