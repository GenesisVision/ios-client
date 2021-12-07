//
//  FundAssetManageCollectionViewCell.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 07.08.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import UIKit


struct FundAssetManageCollectionViewCellViewModel {
    let assetModel: FundAssetInfo?
    let reallocateMode: Bool?
    let closeButtonDelegate: FundAssetCellRemoveButtonProtocol?
}

protocol FundAssetCellRemoveButtonProtocol: AnyObject {
    func remove(assetInfo: FundAssetInfo)
}

extension FundAssetManageCollectionViewCellViewModel: CellViewModel {
    func setup(on cell: FundAssetManageCollectionViewCell) {
        cell.configure(assetModel, reallocateMode: reallocateMode, closeButtonDelegate: closeButtonDelegate)
    }
}

class FundAssetManageCollectionViewCell: BaseCollectionViewCell {
    // MARK: - Variables
    @IBOutlet weak var logoImageView: UIImageView! {
       didSet {
           logoImageView.roundCorners()
       }
    }
    @IBOutlet weak var symbolLabel: TitleLabel! {
        didSet {
            symbolLabel.font = UIFont.getFont(.regular, size: 14)
        }
    }
    @IBOutlet weak var percentLabel: TitleLabel! {
        didSet {
            percentLabel.font = UIFont.getFont(.bold, size: 14)
        }
    }
    @IBOutlet weak var closeView: UIButton! {
        didSet {
            
        }
    }
    @IBOutlet weak var closeButton: UIButton! {
        didSet {
            closeButton.isHidden = true
            closeButton.setImage(#imageLiteral(resourceName: "img_trade_close"), for: .normal)
        }
    }
    
    private var assetModel: FundAssetInfo?
    
    weak var closeButtonDelegate: FundAssetCellRemoveButtonProtocol?
    
    @IBOutlet weak var viewWithData: UIView!
    
    func configure(_ assetModel: FundAssetInfo?, reallocateMode: Bool?, closeButtonDelegate: FundAssetCellRemoveButtonProtocol?) {
        if let logo = assetModel?.logoUrl, let fileUrl = getFileURL(fileName: logo) {
            logoImageView.isHidden = false
            logoImageView.image = #imageLiteral(resourceName: "img_wallet_usdt_icon")
            logoImageView.kf.indicatorType = .activity
            logoImageView.kf.setImage(with: fileUrl)
        } else {
            logoImageView.isHidden = true
        }
        if let symbol = assetModel?.symbol {
            symbolLabel.text = symbol
            symbolLabel.isHidden = false
        } else {
            symbolLabel.isHidden = true
        }
        if let value = assetModel?.target {
            percentLabel.text = value.toString() + "%"
            percentLabel.isHidden = false
        } else {
            percentLabel.isHidden = true
        }
        
        if assetModel?.logoUrl == nil, assetModel?.asset == nil {
            percentLabel.textAlignment = .center
            percentLabel.textColor = UIColor.primary
        } else {
            percentLabel.textAlignment = .right
            percentLabel.textColor = UIColor.Cell.title
        }
        
        if let reallocateMode = reallocateMode, reallocateMode {
            contentView.bringSubviewToFront(closeView)
            closeButton.isHidden = false
        }
        
        if let assetModel = assetModel {
            self.assetModel = assetModel
        }
        
        self.closeButtonDelegate = closeButtonDelegate
    }
    @IBAction func closeButtonAction(_ sender: UIButton) {
        guard let assetModel = self.assetModel else { return }
        closeButtonDelegate?.remove(assetInfo: assetModel)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        roundCorners(with: Constants.SystemSizes.cornerSize / 2)
    }
}
