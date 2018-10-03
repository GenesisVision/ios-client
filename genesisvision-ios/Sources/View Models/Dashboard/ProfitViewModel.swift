//
//  ProfitViewModel.swift
//  genesisvision-ios
//
//  Created by George on 03/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import UIKit.UITableView

final class ProfitViewModel {
    // MARK: - Variables
    var title = "Profit"
    
    var selectedChartAssetsViewModels: [String] = ["asdasd", "asdasd"]
    
    var selectedChartAssetsDelegateManager: ProfitSelectedChartAssetsDelegateManager?
    
    var dashboardChartValue: DashboardChartValue? {
        didSet {
            //TODO: setupUI()
        }
    }
    
    private var router: DashboardRouter!
    
    // MARK: - Init
    init(withRouter router: DashboardRouter) {
        self.router = router
        
        self.selectedChartAssetsDelegateManager = ProfitSelectedChartAssetsDelegateManager(with: selectedChartAssetsViewModels)
    }
    
    // MARK: - Methods
    func showFilterAssets() {
        
    }
    
    func showFilterTraders() {
        
    }
    
    func fetch() {
        
    }
}

// MARK: - TableView
extension ProfitViewModel {
    // MARK: - Public methods
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [PortfolioAssetTableViewCellViewModel.self]
    }

    func modelsCount() -> Int {
        return selectedChartAssetsViewModels.count
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows(in section: Int) -> Int {
        return modelsCount()
    }
    
    func headerTitle(for section: Int) -> String? {
        return nil
    }
}


final class ProfitSelectedChartAssetsDelegateManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Variables
    var selectedChartAssetsViewModels: [String]?
    
    // MARK: - Lifecycle
    init(with selectedChartAssetsViewModels: [String]?) {
        super.init()
        
        self.selectedChartAssetsViewModels = selectedChartAssetsViewModels
    }
    
    // MARK: - TableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedChartAssetsViewModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PortfolioAssetTableViewCell", for: indexPath) as? PortfolioAssetTableViewCell else {
            let cell = UITableViewCell()
            return cell
        }
        
        if let selectedChartAssetsViewModel = selectedChartAssetsViewModels?[indexPath.row] {
            cell.titleLabel.text = selectedChartAssetsViewModel
        }
        
        return cell
    }
}

