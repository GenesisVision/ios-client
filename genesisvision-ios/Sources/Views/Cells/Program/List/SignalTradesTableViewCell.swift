//
//  SignalTradesTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 30/06/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

protocol SignalTradesProtocol: class {
    func didCloseTrade(_ tradeId: String)
}

class SignalTradesTableViewCell: PlateTableViewCell {

    // MARK: - Variables
    weak var delegate: SignalTradesProtocol?
    var tradeId: String?
    
    // MARK: - Views
    @IBOutlet weak var assetLogoImageView: ProfileImageView!
    
    @IBOutlet weak var closeButton: UIButton! {
        didSet {
            closeButton.setImage(#imageLiteral(resourceName: "img_trade_close"), for: .normal)
        }
    }
    
    @IBOutlet weak var investedImageView: UIImageView! {
        didSet {
            investedImageView.isHidden = true
        }
    }
    
    // MARK: - Labels
    @IBOutlet weak var titleLabel: TitleLabel!
    @IBOutlet weak var dateLabel: SubtitleLabel!
    
    @IBOutlet weak var priceOpenTitleLabel: SubtitleLabel! {
        didSet {
            priceOpenTitleLabel.text = "price open"
        }
    }
    @IBOutlet weak var priceOpenLabel: TitleLabel!
    @IBOutlet weak var priceLabel: TitleLabel!
    @IBOutlet weak var profitLabel: TitleLabel! {
        didSet {
            profitLabel.textColor = UIColor.Cell.greenTitle
        }
    }
    
    @IBOutlet weak var symbolLabel: TitleLabel!
    @IBOutlet weak var volumeLabel: TitleLabel!
    @IBOutlet weak var directionLabel: TitleLabel!
    @IBOutlet weak var dirEntryTitleLabel: SubtitleLabel! {
        didSet {
            dirEntryTitleLabel.text = "dir" 
        }
    }
    @IBOutlet weak var entryLabel: TitleLabel! {
        didSet {
            entryLabel.isHidden = true
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgColor = UIColor.Cell.bg
    }
    
    // MARK: - Actions
    @IBAction func closeButtonAction(_ sender: UIButton) {
        guard let tradeId = tradeId else { return }
        
        delegate?.didCloseTrade(tradeId)
    }
}
