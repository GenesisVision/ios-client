//
//  ProgramTableViewCell.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Charts

protocol ProgramProtocol: class {
    func programDetailDidChangeFavoriteState(with programID: String, value: Bool, request: Bool)
}

class ProgramTableViewCell: PlateTableViewCell {
    
    // MARK: - Variables
    weak var delegate: ProgramProtocol?
    var programId: String?
    
    // MARK: - Views
    @IBOutlet weak var programLogoImageView: ProfileImageView!
    @IBOutlet weak var stackView: UIStackView!

    @IBOutlet weak var favoriteButton: FavoriteButton!
    
    @IBOutlet weak var favoriteStackView: UIView!
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
    
    @IBOutlet weak var programTitleLabel: TitleLabel!
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
    @IBOutlet weak var firstValueLabel: TitleLabel!
    @IBOutlet weak var secondValueLabel: TitleLabel!
    @IBOutlet weak var thirdValueLabel: TitleLabel!
    
    @IBOutlet weak var firstTitleLabel: SubtitleLabel!
    @IBOutlet weak var secondTitleLabel: SubtitleLabel!
    @IBOutlet weak var thirdTitleLabel: SubtitleLabel!
    
    
    @IBOutlet weak var bottomStackView: UIStackView! {
        didSet {
            bottomStackView.isHidden = true
        }
    }
    
    @IBOutlet weak var statusButton: StatusButton!
    
    @IBOutlet weak var reinvestSwitch: UISwitch!
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
    }
    
    // MARK: - Public methods

    // MARK: - Actions
    @IBAction func favoriteButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        guard let programId = programId else { return }
        delegate?.programDetailDidChangeFavoriteState(with: programId, value: sender.isSelected, request: true)
    }
}
