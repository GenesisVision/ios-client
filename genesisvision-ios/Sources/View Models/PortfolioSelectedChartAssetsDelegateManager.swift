//
//  PortfolioSelectedChartAssetsDelegateManager.swift
//  genesisvision-ios
//
//  Created by George on 09/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableView

final class PortfolioSelectedChartAssetsDelegateManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Variables
    var viewModel: PortfolioViewModel?
    
    // MARK: - Lifecycle
    init(with viewModel: PortfolioViewModel?) {
        super.init()
        
        self.viewModel = viewModel
    }
    
    // MARK: - TableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows(in: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let model = viewModel?.model(at: indexPath) {
            return tableView.dequeueReusableCell(withModel: model, for: indexPath)
        }
        
        
        return UITableViewCell()
    }
}

