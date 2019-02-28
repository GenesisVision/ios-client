//
//  ProgramTableViewCell.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Charts

class RoundedBackgroundView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = UIColor.white.withAlphaComponent(0.02)
        roundCorners(with: 8)
    }
}
    
class FundAssetView: RoundedBackgroundView {
    @IBOutlet weak var assetLogoImageView: UIImageView! {
        didSet {
            assetLogoImageView.roundCorners()
        }
    }
    @IBOutlet weak var assetPercentLabel: TitleLabel!
}

class ProgramTableViewCell: PlateTableViewCell {
    
    // MARK: - Variables
    weak var delegate: FavoriteStateChangeProtocol?
    weak var reinvestProtocol: SwitchProtocol?
    
    var assetId: String?
    
    // MARK: - Views
    @IBOutlet weak var assetLogoImageView: ProfileImageView!
    @IBOutlet weak var stackView: UIStackView!

    @IBOutlet weak var ratingPlaceHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var ratingLabel: RoundedLabel! {
        didSet {
            ratingLabel.isHidden = true
            ratingLabel.textColor = UIColor.Cell.subtitle
            ratingLabel.backgroundColor = UIColor.black.withAlphaComponent(0.14)
        }
    }
    
    @IBOutlet weak var favoriteButton: FavoriteButton!
    
    @IBOutlet weak var viewForChartView: UIView!
    @IBOutlet weak var chartView: ChartView! {
        didSet {
            chartView.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var investedImageView: UIImageView! {
        didSet {
            investedImageView.isHidden = true
        }
    }
    // MARK: - Labels
    @IBOutlet weak var noDataLabel: SubtitleLabel!
    
    @IBOutlet weak var titleLabel: TitleLabel!
    @IBOutlet weak var managerNameLabel: SubtitleLabel! {
        didSet {
            managerNameLabel.textColor = UIColor.primary
        }
    }

    
    @IBOutlet weak var currencyLabel: CurrencyLabel!
    
    @IBOutlet weak var profitPercentLabel: TitleLabel! {
        didSet {
            profitPercentLabel.textColor = UIColor.Cell.greenTitle
        }
    }
    @IBOutlet weak var profitValueLabel: SubtitleLabel!
    
    @IBOutlet weak var periodLeftProgressView: CircularProgressView! {
        didSet {
            periodLeftProgressView.foregroundStrokeColor = UIColor.primary
            periodLeftProgressView.backgroundStrokeColor = UIColor.primary.withAlphaComponent(0.2)
        }
    }
    
    @IBOutlet weak var firstStackView: UIStackView!
    @IBOutlet weak var secondStackView: UIStackView!
    @IBOutlet weak var thirdStackView: UIStackView!
    
    @IBOutlet weak var firstValueLabel: TitleLabel!
    @IBOutlet weak var secondValueLabel: TitleLabel!
    @IBOutlet weak var thirdValueLabel: TitleLabel!
    
    @IBOutlet weak var firstTitleLabel: SubtitleLabel!
    @IBOutlet weak var secondTitleLabel: SubtitleLabel!
    @IBOutlet weak var thirdTitleLabel: SubtitleLabel!
    
    
    @IBOutlet weak var dashboardBottomStackView: UIStackView! {
        didSet {
            dashboardBottomStackView.isHidden = true
        }
    }
    
    @IBOutlet weak var tagsBottomStackView: UIStackView! {
        didSet {
            tagsBottomStackView.isHidden = true
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
    @IBOutlet weak var otherTagLabel: RoundedLabel! {
        didSet {
            otherTagLabel.isHidden = true
        }
    }
    
    @IBOutlet weak var fundBottomStackView: UIStackView! {
        didSet {
            fundBottomStackView.isHidden = true
        }
    }
    @IBOutlet weak var firstFundAssetView: FundAssetView! {
        didSet {
            firstFundAssetView.isHidden = true
        }
    }
    @IBOutlet weak var secondFundAssetView: FundAssetView! {
        didSet {
            secondFundAssetView.isHidden = true
        }
    }
    @IBOutlet weak var thirdFundAssetView: FundAssetView! {
        didSet {
            thirdFundAssetView.isHidden = true
        }
    }
    @IBOutlet weak var otherFundAssetView: FundAssetView! {
        didSet {
            otherFundAssetView.isHidden = true
        }
    }
    
    @IBOutlet weak var statusButton: StatusButton! 
    @IBOutlet weak var reinvestSwitch: UISwitch! {
        didSet {
            reinvestSwitch.onTintColor = UIColor.primary
            reinvestSwitch.thumbTintColor = UIColor.Cell.switchThumbTint
            reinvestSwitch.tintColor = UIColor.Cell.switchTint
        }
    }
    @IBOutlet weak var reinvestLabel: TitleLabel! {
        didSet {
            reinvestLabel.font = UIFont.getFont(.semibold, size: 12.0)
        }
    }
    @IBOutlet weak var reinvestTooltip: TooltipButton! {
        didSet {
            reinvestTooltip.tooltipText = "Reinvest Tooltip"
            reinvestTooltip.isHidden = true
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.ratingPlaceHeightConstraint.constant = 0.0
        bgColor = UIColor.Cell.bg
    }
    
    // MARK: - Public methods

    // MARK: - Actions
    @IBAction func favoriteButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        guard let assetId = assetId else { return }
        delegate?.didChangeFavoriteState(with: assetId, value: sender.isSelected, request: true)
    }
    
    @IBAction func reinvestSwitchAction(_ sender: UISwitch) {
        if let assetId = assetId {
            reinvestProtocol?.didChangeSwitch(value: sender.isOn, assetId: assetId)
        }
    }
}
