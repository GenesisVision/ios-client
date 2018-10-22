//
//  TableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 11/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//


import UIKit

class TableViewCell: UITableViewCell {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.BaseView.bg
        
        tintColor = UIColor.Cell.title
        accessoryView?.backgroundColor = UIColor.BaseView.bg
    }
}

