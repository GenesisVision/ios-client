//
//  FilterTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 09/11/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

enum FilterStyle {
    case switcher
    case detail
}

struct FilterTableViewCellViewModel {
    var title: String
    var detail: String?
    var detailImage: UIImage?
    var switchOn: Bool?
    var style: FilterStyle
    var delegate: FilterTableViewCellProtocol?
}

extension FilterTableViewCellViewModel: CellViewModel {
    func setup(on cell: FilterTableViewCell) {
        cell.delegate = delegate
        
        cell.titleLabel?.text = title
        
        cell.switcher.isHidden = style == .detail
        cell.detailStackView.isHidden = style == .switcher
        
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
        
        if let switchOn = switchOn {
            cell.switcher.isOn = switchOn
            cell.selectionStyle = .none
        }
    }
}
