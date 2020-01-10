//
//  BaseTabmanViewController.swift
//  genesisvision-ios
//
//  Created by George on 07/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Tabman
import UIKit.UINavigationController

class BaseTabmanViewController<T: TabmanViewModel>: TabmanViewController {
    
    // MARK: - View Model
    var viewModel: T!
    var bar: TMBarView = TMBar.ButtonBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }

    // MARK: - Private methods
    private func setup() {
        dataSource = viewModel.dataSource
        navigationItem.title = viewModel.title
        
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = viewModel.backgroundColor
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .done, target: nil, action: nil)
        
        isScrollEnabled = viewModel.isScrollEnabled
        bar.scrollMode = viewModel.isScrollEnabled ? .interactive : .none
        
        bounces = viewModel.bounces
        
        bar.layout.transitionStyle = .snap
        bar.layout.separatorColor = UIColor.primary
        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

        bar.buttons.customize { (button) in
            button.tintColor = UIColor.Cell.subtitle
            button.selectedTintColor = UIColor.Cell.title
            button.font = self.viewModel.font
            button.selectedFont = self.viewModel.font
            button.badge.textColor = UIColor.primary
            button.badge.tintColor = UIColor.primary.withAlphaComponent(0.1)
        }

        bar.backgroundView.style = .flat(color: self.viewModel.backgroundColor)
        bar.fadesContentEdges = true
        bar.indicator.tintColor = UIColor.primary
        bar.indicator.isProgressive = viewModel.isProgressive
        bar.indicator.weight = .light
        
        if viewModel.bounces {
            bar.indicator.overscrollBehavior = .bounce
        } else if viewModel.compresses {
            bar.indicator.overscrollBehavior = .compress
        }
        
        addBar(bar, dataSource: viewModel.dataSource ?? self, at: .top)
    }

    // MARK: - Private methods
    @objc private func totalCountDidChangeNotification(notification: Notification) {
        print(tabmanBarItems?.count ?? "")
        if let title = notification.userInfo?["title"] as? String, let totalCount = notification.userInfo?["totalCount"] as? Int {
            tabmanBarItems?.forEach({ (item) in
                if item.title == title {
                    item.badgeValue = "\(totalCount)"
                }
            })
        }
    }
}

extension BaseTabmanViewController: TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        guard let items = viewModel.items else { return TMBarItem(title: "") }
        let item = items[index]

        return item
    }
}
