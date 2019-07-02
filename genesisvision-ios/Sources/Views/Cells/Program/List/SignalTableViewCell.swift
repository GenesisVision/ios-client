//
//  SignalTableViewCell.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class SignalTableViewCell: PlateTableViewCell {
    
    // MARK: - Variables
    weak var delegate: FavoriteStateChangeProtocol?
    
    var assetId: String?
    
    // MARK: - Views
    @IBOutlet weak var assetLogoImageView: ProfileImageView!
    @IBOutlet weak var stackView: UIStackView!
   
    @IBOutlet weak var favoriteButton: FavoriteButton!
    
    
    @IBOutlet weak var investedImageView: UIImageView! {
        didSet {
            investedImageView.isHidden = true
        }
    }
    
    // MARK: - Labels
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
    @IBOutlet weak var firstStackView: UIStackView!
    @IBOutlet weak var secondStackView: UIStackView!
    @IBOutlet weak var thirdStackView: UIStackView!
    
    @IBOutlet weak var firstValueLabel: TitleLabel!
    @IBOutlet weak var secondValueLabel: TitleLabel!
    @IBOutlet weak var thirdValueLabel: TitleLabel!
    
    @IBOutlet weak var firstTitleLabel: SubtitleLabel!
    @IBOutlet weak var secondTitleLabel: SubtitleLabel!
    @IBOutlet weak var thirdTitleLabel: SubtitleLabel!
    
    
    @IBOutlet weak var statusButton: StatusButton! 
   
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgColor = UIColor.Cell.bg
    }
    
    // MARK: - Public methods

    // MARK: - Actions
    @IBAction func favoriteButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        guard let assetId = assetId else { return }
        delegate?.didChangeFavoriteState(with: assetId, value: sender.isSelected, request: true)
    }
}
