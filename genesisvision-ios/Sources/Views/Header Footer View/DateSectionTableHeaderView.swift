//
//  DateSectionTableHeaderView.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.19.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//


import UIKit

class DateSectionTableHeaderView: UITableViewHeaderFooterView {

    static let font = UIFont.getFont(.semibold, size: 12)
    
    static var titleInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    @IBOutlet weak var headerBackgroundView: UIView!
        
    @IBOutlet weak var headerLabel: UILabel! {
        didSet {
            headerLabel.font = DateSectionTableHeaderView.font
            headerLabel.textColor = UIColor.Cell.title
            headerLabel.layoutMargins = DateSectionTableHeaderView.titleInsets
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor.Cell.headerBg
        headerBackgroundView.backgroundColor = UIColor.BaseView.bg
    }
}
