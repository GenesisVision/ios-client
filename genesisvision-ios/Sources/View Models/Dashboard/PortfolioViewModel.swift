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
    
    var viewModels = [PortfolioAssetTableViewCellViewModel]()
    var selectedChartAssets: [AssetsValue]? {
        didSet {
            var portfolioAssetTableViewCellViewModels = [PortfolioAssetTableViewCellViewModel]()
            
            selectedChartAssets?.forEach({ (selectedChartAsset) in
                let portfolioAssetTableViewCellViewModel = PortfolioAssetTableViewCellViewModel(selectedChartAssets: selectedChartAsset)
                portfolioAssetTableViewCellViewModels.append(portfolioAssetTableViewCellViewModel)
            })
            
            viewModels = portfolioAssetTableViewCellViewModels
        }
    }
    
    var valueChartBar: ValueChartBar? {
        didSet {
            self.selectedChartAssets = valueChartBar?.topAssets
        }
    }
    
    var selectedChartAssetsDelegateManager: PortfolioSelectedChartAssetsDelegateManager?
    weak var reloadDataProtocol: ReloadDataProtocol?
    var dashboardChartValue: DashboardChartValue?
    var programRequests: ProgramRequests?
    
    private var router: DashboardRouter!
    
    // MARK: - Init
    init(withRouter router: DashboardRouter, dashboardChartValue: DashboardChartValue?) {
        self.router = router
        self.dashboardChartValue = dashboardChartValue
        self.selectedChartAssetsDelegateManager = PortfolioSelectedChartAssetsDelegateManager(with: self)
    }
    
    // MARK: - Methods
    func selectChart(_ date: Date) -> ValueChartBar? {
        if let result = dashboardChartValue?.investedProgramsInfo?.first(where: { $0.date == date }) {
            self.valueChartBar = result
            self.selectedChartAssetsDelegateManager?.reloadData()
            return self.valueChartBar
        }
        
        return nil
    }
    
    func showRequests() {
        guard let requests = programRequests?.requests, requests.count > 0 else { return }
        
        router.show(routeType: .requests(programRequests: programRequests))
    }
}

// MARK: - TableView
extension PortfolioViewModel {
    // MARK: - Public methods
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [PortfolioAssetTableViewCellViewModel.self]
    }
    
    func modelsCount() -> Int {
        return viewModels.count
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
    
    func model(at indexPath: IndexPath) -> PortfolioAssetTableViewCellViewModel? {
        return viewModels[indexPath.row]
    }
}
