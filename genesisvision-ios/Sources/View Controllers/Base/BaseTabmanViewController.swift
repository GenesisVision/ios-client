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

class BaseTabmanViewController<T: TabmanViewModel>: TabmanViewController {
    
    // MARK: - View Model
    var viewModel: T!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Private methods
    private func setup() {
        viewModel.initializeViewControllers()
        
        dataSource = self
        navigationItem.setTitle(title: viewModel.title, subtitle: getFullVersion())
        
        setupUI()
    }
    private func setupUI() {
        view.backgroundColor = UIColor.BaseView.bg
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .done, target: nil, action: nil)
        
        bar.style = viewModel.style
        bar.location = viewModel.location
        
        isScrollEnabled = viewModel.isScrollEnabled
        
        bar.appearance = TabmanBar.Appearance({ (appearance) in
            appearance.interaction.isScrollEnabled = viewModel.isScrollEnabled
            
            appearance.state.selectedColor = UIColor.primary
            appearance.state.shouldHideWhenSingleItem = viewModel.shouldHideWhenSingleItem
            
            appearance.style.imageRenderingMode = .alwaysTemplate
            appearance.style.showEdgeFade = false
            appearance.style.background = .solid(color: UIColor.BaseView.bg)
            
            appearance.indicator.color = UIColor.primary
            appearance.indicator.bounces = viewModel.bounces
            appearance.indicator.isProgressive = viewModel.isProgressive
            appearance.indicator.compresses = viewModel.compresses
            
            appearance.text.font = UIFont.getFont(.regular, size: 15)
            
            switch bar.style {
            case .buttonBar:
                appearance.layout.interItemSpacing = 8.0
                appearance.layout.edgeInset = 0.0
            default:
                appearance.layout.interItemSpacing = 20.0
                appearance.layout.edgeInset = 16.0
            }
        })
    }
}

extension BaseTabmanViewController: TabmanViewModelDelegate {
    func updatedItems() {
        var barItems = [Item]()
        
        for itemTitle in viewModel.itemTitles {
            barItems.append(Item(title: itemTitle.uppercased()))
        }
        
        bar.items = barItems
        
        setupUI()
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
        return viewModel.defaultPage
    }
}
