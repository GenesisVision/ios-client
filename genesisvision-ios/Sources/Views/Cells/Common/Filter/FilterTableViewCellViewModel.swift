//
//  FilterTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 09/11/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

struct FilterTableViewCellViewModel {
    var title: String
    var detail: String?
    var detailImage: UIImage?
}

extension FilterTableViewCellViewModel: CellViewModel {
    func setup(on cell: FilterTableViewCell) {
        cell.titleLabel?.text = title
        
        if let detail = detail {
            cell.detailLabel?.text = detail
        } else {
            cell.detailLabel.text = nil
        }
        
        if let detailImage = detailImage {
            cell.detailImageView.image = detailImage.withRenderingMode(.alwaysTemplate)
        } else {
            cell.detailImageView.image = nil
        }
    }
}
