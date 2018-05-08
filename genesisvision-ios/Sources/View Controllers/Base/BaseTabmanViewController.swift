//
//  BaseTabmanViewController.swift
//  genesisvision-ios
//
//  Created by George on 07/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Tabman
import Pageboy

class BaseTabmanViewController: TabmanViewController {
    
    // MARK: - View Model
    var viewModel: TabmanViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Private methods
    func setup() {
        navigationItem.setTitle(title: viewModel.title, subtitle: getVersion())
        
        self.dataSource = self
        
        var barItems = [Item]()
        
        for itemTitle in viewModel.itemTitles {
            barItems.append(Item(title: itemTitle))
        }

        bar.items = barItems
        bar.style = viewModel.style
        bar.location = .top

        bar.appearance = TabmanBar.Appearance({ (appearance) in
            appearance.interaction.isScrollEnabled = viewModel.isScrollEnabled
            appearance.style.background = .clear
            appearance.style.showEdgeFade = true
            appearance.indicator.color = UIColor.primary
            appearance.state.selectedColor = UIColor.primary
            appearance.text.font = UIFont.getFont(.light, size: 21)
        })
    }
}

extension BaseTabmanViewController: PageboyViewControllerDataSource {
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewModel.viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewModel.viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return .first
    }
}
