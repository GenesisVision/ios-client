//
//  PortfolioViewModel.swift
//  genesisvision-ios
//
//  Created by George on 24/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import UIKit.UITableView

final class PortfolioViewModel {
    // MARK: - Variables
    var title = "Portfolio"
    
    var selectedChartAssetsViewModels: [String] = ["asdasd", "asdasd"]
    
    var selectedChartAssetsDelegateManager: SelectedChartAssetsDelegateManager?
    
    private var router: DashboardRouter!
    
    // MARK: - Init
    init(withRouter router: DashboardRouter) {
        self.router = router
        
        self.selectedChartAssetsDelegateManager = SelectedChartAssetsDelegateManager(with: selectedChartAssetsViewModels)
    }
    
    // MARK: - Methods
    func showRequests() {
        router.show(routeType: .requests)
    }
}

// MARK: - TableView
extension PortfolioViewModel {
    // MARK: - Public methods
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [PortfolioAssetTableViewCellViewModel.self]
    }
    
    /// Return view models for registration header/footer Nib files
    var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] {
        return [SegmentedHeaderFooterView.self]
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


final class SelectedChartAssetsDelegateManager: NSObject, UITableViewDelegate, UITableViewDataSource {
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
