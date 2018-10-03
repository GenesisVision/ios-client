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
import UIKit.UINavigationController

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
        
        dataSource = viewModel.pageboyDataSource
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
            
            appearance.state.selectedColor = UIColor.Cell.title
            appearance.state.color = UIColor.Cell.subtitle
            appearance.state.shouldHideWhenSingleItem = viewModel.shouldHideWhenSingleItem
            
            appearance.style.imageRenderingMode = .alwaysTemplate
            appearance.style.showEdgeFade = false
            appearance.style.background = .solid(color: UIColor.BaseView.bg)
            
            appearance.indicator.color = UIColor.primary
            appearance.indicator.bounces = viewModel.bounces
            appearance.indicator.isProgressive = viewModel.isProgressive
            appearance.indicator.compresses = viewModel.compresses
            
            appearance.text.font = viewModel.font
            
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
            barItems.append(Item(title: itemTitle))
        }
        
        bar.items = barItems
        
        setupUI()
    }
}
