//
//  AboutLevelsViewController.swift
//  genesisvision-ios
//
//  Created by George on 06/12/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class LevelStackView: UIStackView {
    @IBOutlet weak var levelButton: RatingLevelButton!
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
            titleLabel.font = UIFont.getFont(.semibold, size: 16.0)
        }
    }
    
    @IBOutlet weak var textLabel: SubtitleLabel! {
        didSet {
            textLabel.textColor = UIColor.Cell.title
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
        
        subtitleLabel.text = "Genesis level reflects the experience and reliability of a manager.\n\nAll of the investment programs of a non-verified manager are limited to the first level and can’t level up unless the manager passes the KYC procedure. Once the verification process is completed, the investment programs of a manager are levelled up to the second level.\n\nStarting from the second level, the level will depend on Av. to invest and is  subject to constant change.\n\nThe available amount of money for investing in the manager is calculated as"
        subtitleLabel.setLineSpacing(lineSpacing: 3.0)
        
        titleLabel.text = "Investment Scale * Manager balance."
        
        let text = "Investment Scale is calculated according to a formula that takes into account:\n\n1. The Age of the program\n2. The Success of the trading manager.The Success of the trading manager is calculated with the help of the Genesis Ratio, which is the ratio of the program profit to its risk. The formula is similar to the Sharpe ratio and is set in a range from 0 to 1.If Genesis Ratio <0.2, then the program is high risk and the Investment scale is limited to 1 meaning that the manager can attract no more than his own deposit.\n3. The trading volume (Weighted volume scale)\nThis is a multiplier of the volume traded by the manager relative to the program balance for all periods. It is calculated similarly to the Genesis Ratio, being a weighted average over all periods.\n\nTo have a volume multiplier of 1 the managers weekly trading volume needs to be approximately the same as the amount of funds in his/her program. In the case of Forex programs, the volume is divided by the shoulder.\n\nThe coefficient is designed so that trading more in one period can compensate for the lack ofvolume during another period, but one-time high volumes won’t compensate for the lack of trading.\n\nNotes:\nIf the investor funds in the program exceed Av.to invest, then the Success Fee and Stop out Level are decreased until the investor funds in the program become less or equal to Av. to invest. This change takes effect in the new period.\n\nIf the manager is not verified, the available investment limit is always $1000, translated into account currency. Otherwise, the available limit is set in the range from $5k to $300k."
        
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
        
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
}
