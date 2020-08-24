//
//  FundAssetsListTableViewCell.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 19.08.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import UIKit

struct FundAssetsListTableViewCellViewModel {
    let assetModel: PlatformAsset?
}

extension FundAssetsListTableViewCellViewModel: CellViewModel {
    func setup(on cell: FundAssetsListTableViewCell) {
        cell.configure(assetModel)
    }
}

class FundAssetsListTableViewCell: UITableViewCell {
    // MARK: - Variables
    @IBOutlet weak var logoImageView: UIImageView! {
        didSet {
            logoImageView.roundCorners()
        }
    }
    @IBOutlet weak var titleLabel: TitleLabel! {
        didSet {
            titleLabel.font = UIFont.getFont(.regular, size: 16.0)
        }
    }
    @IBOutlet weak var subtitleLabel: SubtitleLabel! {
        didSet {
            subtitleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    
    var assetModel: PlatformAsset?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.Cell.bg
        contentView.backgroundColor = UIColor.Cell.bg
        tintColor = UIColor.Cell.title
        accessoryView?.backgroundColor = UIColor.Cell.bg
        
        selectionStyle = .none
    }
    
    func configure(_ assetModel: PlatformAsset?) {
        self.assetModel = assetModel
        
        logoImageView.image = #imageLiteral(resourceName: "img_wallet_usdt_icon")
        
        if let logo = assetModel?.logoUrl, let fileUrl = getFileURL(fileName: logo) {
            logoImageView.kf.indicatorType = .activity
            logoImageView.kf.setImage(with: fileUrl)
        }
        if let name = assetModel?.name {
            titleLabel.text = name
        }
        if let symbol = assetModel?.asset {
            subtitleLabel.text = symbol
        }
    }
}
