//
//  DefaultTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 18/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

struct DefaultTableViewCellViewModel {
    var title: String?
    var subtitle: String?
    weak var editInfoProtoclDelegate: EditInfoProtocol?
    var assetType: AssetType?
    var isOwner: Bool?
}

extension DefaultTableViewCellViewModel: CellViewModel {
    func setup(on cell: DefaultTableViewCell) {
        if let title = title {
            cell.titleLabel.text = title
        }
        
        if let subtitle = subtitle {
            cell.subtitleLabel.text = subtitle
        }
        
        if let isOwner = isOwner, isOwner, let assetType = assetType, assetType == .fund {
            cell.editInfoButton.isHidden = false
        }
        
        cell.editInfoProtocolDelegate = editInfoProtoclDelegate
    }
}
