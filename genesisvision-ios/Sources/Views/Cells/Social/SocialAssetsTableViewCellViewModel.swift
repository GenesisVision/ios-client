//
//  SocialAssetsTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by Gregory on 09.02.2022.
//  Copyright © 2022 Genesis Vision. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher


struct SocialAssetsTableViewCellViewModel {
    var assetName : String?
    var assetImage : String?
    var tagType: TagType?
    var assetURL : String?
}

enum TagType : String {
    case program = "Program"
    case fund = "Fund"
    case follow = "Follow"
    case user = "User"
}
extension SocialAssetsTableViewCellViewModel {
    func setup(on cell : SocialAssetsTableViewCell) {
        if let name = assetName {
            cell.assetNameLabel.text = name
        }
        if let image = assetImage, let fileUrl = getFileURL(fileName: image) {
            cell.assetImageView.kf.setImage(with: fileUrl)
            cell.assetImageView.backgroundColor = .clear
        } else {
            cell.assetImageView.image = UIImage.programPlaceholder
            cell.assetImageView.backgroundColor = .random
        }
        if let type = tagType {
            cell.assetTypeLabel.text = type.rawValue
        }
    }
}

class SocialAssetsTableViewCell : UITableViewCell {
    
    @IBOutlet weak var assetImageView: UIImageView!
    @IBOutlet weak var assetNameLabel: UILabel!
    @IBOutlet weak var assetTypeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        assetImageView.layer.cornerRadius = 8.0
        assetImageView.clipsToBounds = true
    }
   
}
