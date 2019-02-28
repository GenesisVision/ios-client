//
//  DefaultTableHeaderView.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 05.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//


import UIKit

class DefaultTableHeaderView: UITableViewHeaderFooterView {

    static let font = UIFont.getFont(.semibold, size: 18)
    
    static var titleInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }

    @IBOutlet weak var headerBackgroundView: UIView!
        
    @IBOutlet weak var headerLabel: UILabel! {
        didSet {
            headerLabel.font = DefaultTableHeaderView.font
            headerLabel.textColor = UIColor.Cell.title
            headerLabel.layoutMargins = DefaultTableHeaderView.titleInsets
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor.Cell.headerBg
        headerBackgroundView.backgroundColor = UIColor.BaseView.bg
    }
}
