//
//  DefaultTableHeaderView.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 05.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//


import UIKit

class DefaultTableHeaderView: UITableViewHeaderFooterView {

    static let font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.bold)
    
    static var titleInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }

    @IBOutlet var headerLabel: UILabel! {
        didSet {
            headerLabel.font = DefaultTableHeaderView.font
            headerLabel.textColor = UIColor.Font.dark
            headerLabel.layoutMargins = DefaultTableHeaderView.titleInsets
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor.Background.gray
    }
}
