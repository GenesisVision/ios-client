//
//  ProgramTableViewCell.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Charts

class ProgramTableViewCell: PlateTableViewCell {
    
    // MARK: - Variables
    weak var delegate: ProgramDetailViewControllerProtocol?
    var programId: String?
    
    // MARK: - Views
    @IBOutlet var programLogoImageView: ProfileImageView!
    @IBOutlet var stackView: UIStackView!

    @IBOutlet var favoriteButton: FavoriteButton!
    
    @IBOutlet var favoriteStackView: UIView!
    @IBOutlet var viewForChartView: UIView!
    @IBOutlet var chartView: ChartView! {
        didSet {
            chartView.isUserInteractionEnabled = false
        }
    }
    
    // MARK: - Labels
    @IBOutlet var noDataLabel: SubtitleLabel!
    
    @IBOutlet var programTitleLabel: TitleLabel!
    @IBOutlet var managerNameLabel: SubtitleLabel! {
        didSet {
            managerNameLabel.textColor = UIColor.primary
        }
    }

    
    @IBOutlet var currencyLabel: CurrencyLabel!
    
    @IBOutlet var profitPercentLabel: TitleLabel! {
        didSet {
            profitPercentLabel.textColor = UIColor.Cell.greenTitle
        }
    }
    @IBOutlet var profitValueLabel: SubtitleLabel!
    
    @IBOutlet weak var periodLeftProgressView: CircularProgressView! {
        didSet {
            periodLeftProgressView.foregroundStrokeColor = UIColor.primary
            periodLeftProgressView.backgroundStrokeColor = UIColor.primary.withAlphaComponent(0.2)
        }
    }
    @IBOutlet var firstValueLabel: TitleLabel!
    @IBOutlet var secondValueLabel: TitleLabel!
    @IBOutlet var thirdValueLabel: TitleLabel!
    
    @IBOutlet var firstTitleLabel: SubtitleLabel!
    @IBOutlet var secondTitleLabel: SubtitleLabel!
    @IBOutlet var thirdTitleLabel: SubtitleLabel!
    
    
    @IBOutlet var bottomStackView: UIStackView! {
        didSet {
            bottomStackView.isHidden = true
        }
    }
    
    @IBOutlet var statusButton: StatusButton!
    
    @IBOutlet var reinvestSwitch: UISwitch!
    @IBOutlet var reinvestLabel: TitleLabel! {
        didSet {
            reinvestLabel.font = UIFont.getFont(.semibold, size: 12.0)
        }
    }
    @IBOutlet var reinvestTooltip: TooltipButton! {
        didSet {
            reinvestTooltip.tooltipText = "Reinvest Tooltip"
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Public methods

    // MARK: - Actions
    @IBAction func favoriteButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        guard let programId = programId else { return }
        delegate?.programDetailDidChangeFavoriteState(with: programId, value: sender.isSelected, request: true)
    }
}
