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
    @IBOutlet var programDetailsView: ProgramDetailsForTableViewCellView!
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
    @IBOutlet var noDataLabel: UILabel! {
        didSet {
            noDataLabel.textColor = UIColor.Cell.title
        }
    }
    
    @IBOutlet var programTitleLabel: UILabel! {
        didSet {
            programTitleLabel.textColor = UIColor.Cell.title
        }
    }
    @IBOutlet var managerNameLabel: UILabel! {
        didSet {
            managerNameLabel.textColor = UIColor.Cell.subtitle
        }
    }
    
    @IBOutlet var currencyLabel: CurrencyLabel!
    @IBOutlet var placeLabel: TournamentPlaceLabel!
    
    @IBOutlet var bottomStackView: UIStackView! {
        didSet {
            bottomStackView.isHidden = true
        }
    }
    
    @IBOutlet var statusLabel: RoundedLabel! {
        didSet {
            statusLabel.setProperties(font: UIFont.getFont(.regular, size: 13.0),
                                           textColor: UIColor.Cell.yellowTitle,
                                           backgroundColor: UIColor.Cell.yellowTitle.withAlphaComponent(0.3),
                                           edgeInsets: UIEdgeInsets(top: 8.0, left: 20.0, bottom: 8.0, right: 20.0))
        }
    }
    
    @IBOutlet var changeValueLabel: RoundedLabel! {
        didSet {
            changeValueLabel.setProperties(font: UIFont.getFont(.bold, size: 19.0),
                                           textColor: UIColor.Cell.greenTitle,
                                           backgroundColor: UIColor.Cell.greenTitle.withAlphaComponent(0.3),
                                           edgeInsets: UIEdgeInsets(top: 8.0, left: 16.0, bottom: 8.0, right: 16.0))
        }
    }
    
    @IBOutlet var balanceValueLabel: UILabel! {
        didSet {
            balanceValueLabel.textColor = UIColor.Cell.subtitle
            balanceValueLabel.font = UIFont.getFont(.regular, size: 19.0)
        }
    }
    
    @IBOutlet var reinvestSwitch: UISwitch!
    @IBOutlet var reinvestLabel: UILabel! {
        didSet {
            reinvestLabel.textColor = UIColor.Cell.title
        }
    }
    @IBOutlet var reinvestTooltip: TooltipButton! {
        didSet {
            //TODO: Tooltip text
            reinvestTooltip.tooltipText = "Reinvest Tooltip"
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        currencyLabel.isHidden = true
    }
    
    // MARK: - Public methods
    func tournamentActive(_ isTournament: Bool) {
        placeLabel.isHidden = !isTournament
    }
    
    // MARK: - Actions
    @IBAction func favoriteButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        guard let programId = programId else { return }
        delegate?.programDetailDidChangeFavoriteState(with: programId, value: sender.isSelected, request: true)
    }
}
