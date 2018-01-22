//
//  UITableView+Configure.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableView

struct TableViewConfiguration {
    var topInset: CGFloat?
    var bottomInset: CGFloat?
    var bottomIndicatorInset: CGFloat?
    var estimatedRowHeight: CGFloat
    var rowHeight: CGFloat
    var backgroundColor: UIColor
    
    init(
        topInset: CGFloat? = nil,
        bottomInset: CGFloat? = nil,
        bottomIndicatorInset: CGFloat? = nil,
        estimatedRowHeight: CGFloat = 0,
        rowHeight: CGFloat = UITableViewAutomaticDimension,
        backgroundColor: UIColor = UIColor.lightGray
        ) {
        self.topInset = topInset
        self.bottomInset = bottomInset
        self.estimatedRowHeight = estimatedRowHeight
        self.bottomIndicatorInset = bottomIndicatorInset
        self.rowHeight = rowHeight
        self.backgroundColor = backgroundColor
    }
    
    static var defaultConfig = defaultConfiguration
}

private var defaultConfiguration: TableViewConfiguration {
    return TableViewConfiguration(
        topInset: 0,
        bottomInset: 0,
        estimatedRowHeight: 140,
        rowHeight: UITableViewAutomaticDimension
    )
}

extension UITableView {
    enum ConfigurationType {
        case defaultConfiguration
        case custom(TableViewConfiguration)
    }
    
    func configure(with configuration: ConfigurationType) {
        switch configuration {
        case .defaultConfiguration:
            setup(configuration: defaultConfiguration)
        case let .custom(customConfig):
            setup(configuration: customConfig)
        }
    }
    
    private func setup(configuration: TableViewConfiguration) {
        if let topInset = configuration.topInset {
            self.contentInset.top = topInset
        }
        if let bottomInset = configuration.bottomInset {
            self.contentInset.bottom = bottomInset
        }
        
        if let bottomIndicatorInset = configuration.bottomIndicatorInset {
            self.scrollIndicatorInsets.bottom = bottomIndicatorInset
        }
        
        self.estimatedRowHeight = configuration.estimatedRowHeight
        self.rowHeight = configuration.rowHeight
        
        self.backgroundColor = configuration.backgroundColor
    }
    
}

