//
//  TraderTableViewCell.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Charts

class TraderTableViewCell: PlateTableViewCell {
    
    // MARK: - Variables
    weak var delegate: ProgramDetailViewControllerProtocol?
    var investmentProgramId: String?
    
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
            noDataLabel.textColor = UIColor.Font.dark
        }
    }
    
    @IBOutlet var noAvailableTokensLabel: UILabel! {
        didSet {
            noAvailableTokensLabel.textColor = UIColor.Cell.redTitle
            noAvailableTokensLabel.font = UIFont.getFont(.regular, size: 11)
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
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Actions
    @IBAction func favoriteButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        guard let investmentProgramId = investmentProgramId else { return }
        delegate?.programDetailDidChangeFavoriteState(with: investmentProgramId, value: sender.isSelected, request: true)
    }
}
