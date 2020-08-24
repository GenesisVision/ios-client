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
    var separatorInsetLeft: CGFloat
    var separatorInsetRight: CGFloat
    var separatorInsetTop: CGFloat
    var separatorInsetBottom: CGFloat
    
    init(
        topInset: CGFloat? = 0.0,
        bottomInset: CGFloat? = 0.0,
        bottomIndicatorInset: CGFloat? = nil,
        estimatedRowHeight: CGFloat = 0,
        rowHeight: CGFloat = UITableView.automaticDimension,
        backgroundColor: UIColor = UIColor.BaseView.bg,
        separatorInsetLeft: CGFloat = 16.0,
        separatorInsetRight: CGFloat = 16.0,
        separatorInsetTop: CGFloat = 16.0,
        separatorInsetBottom: CGFloat = 16.0
        ) {
        self.topInset = topInset
        self.bottomInset = bottomInset
        self.estimatedRowHeight = estimatedRowHeight
        self.bottomIndicatorInset = bottomIndicatorInset
        self.rowHeight = rowHeight
        self.backgroundColor = backgroundColor
        self.separatorInsetLeft = separatorInsetLeft
        self.separatorInsetRight = separatorInsetRight
        self.separatorInsetTop = separatorInsetTop
        self.separatorInsetBottom = separatorInsetBottom
    }
    
    static var defaultConfig = defaultConfiguration
}

private var defaultConfiguration: TableViewConfiguration {
    return TableViewConfiguration(
        topInset: 0,
        bottomInset: 0,
        estimatedRowHeight: 140,
        rowHeight: UITableView.automaticDimension,
        separatorInsetLeft: 16.0,
        separatorInsetRight: 16.0
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
        
        self.separatorInset.left = configuration.separatorInsetLeft
        self.separatorInset.right = configuration.separatorInsetRight
        self.separatorInset.top = configuration.separatorInsetTop
        self.separatorInset.bottom = configuration.separatorInsetBottom
    }
}

extension UITableView
{
    func indexPathExists(indexPath:IndexPath) -> Bool {
        if indexPath.section >= self.numberOfSections {
            return false
        }
        if indexPath.row >= self.numberOfRows(inSection: indexPath.section) {
            return false
        }
        return true
    }
}

