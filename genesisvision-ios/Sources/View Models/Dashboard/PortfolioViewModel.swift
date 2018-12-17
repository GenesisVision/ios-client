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
    
    var selectedValueChartBar: ValueChartBar? {
        didSet {
            var portfolioAssetTableViewCellViewModels = [PortfolioAssetTableViewCellViewModel]()
            
            if let topAssets = selectedValueChartBar?.topAssets {
                topAssets.forEach({ (assetsValue) in
                    let portfolioAssetTableViewCellViewModel = PortfolioAssetTableViewCellViewModel(assetsValue: assetsValue, otherAssetsValue: nil)
                    portfolioAssetTableViewCellViewModels.append(portfolioAssetTableViewCellViewModel)
                })
            }
            
            if let otherAssetsValue = selectedValueChartBar?.otherAssetsValue {
                let portfolioAssetTableViewCellViewModel = PortfolioAssetTableViewCellViewModel(assetsValue: nil, otherAssetsValue: otherAssetsValue)
                portfolioAssetTableViewCellViewModels.append(portfolioAssetTableViewCellViewModel)
            }
            
            viewModels = portfolioAssetTableViewCellViewModels
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
    
    // MARK: - Public methods
    func selectChart(_ date: Date) -> (ValueChartBar?, ChartSimple?) {
        var balanceChart: ChartSimple? = nil
        
        if let selectedValueChartBar = dashboardChartValue?.investedProgramsInfo?.first(where: { $0.date == date }) {
            self.selectedValueChartBar = selectedValueChartBar
            self.selectedChartAssetsDelegateManager?.reloadData()
        }
        
        if let selected = dashboardChartValue?.balanceChart?.first(where: { $0.date == date }) {
            balanceChart = selected
        }
        
        return (selectedValueChartBar, balanceChart)
    }
    
    func showRequests() {
        guard let requests = programRequests?.requests, requests.count > 0 else { return }
        
        router.show(routeType: .requests(programRequests: programRequests))
    }
    
    func didSelectAsset(at indexPath: IndexPath) {
        guard !viewModels.isEmpty else {
            return
        }
        
        let selectedModel = viewModels[indexPath.row]
        if let assetId = selectedModel.assetsValue?.id?.uuidString, let type = selectedModel.assetsValue?.type, let assetType = AssetType(rawValue: type.rawValue) {
            router.showAssetDetails(with: assetId, assetType: assetType)
        }
    }
    
    func didHighlightRow(at indexPath: IndexPath) -> Bool {
        let selectedModel = viewModels[indexPath.row]
        return selectedModel.otherAssetsValue == nil
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
