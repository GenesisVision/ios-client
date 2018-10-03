//
//  ProgramFilterViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 31.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import TTRangeSlider

final class ProgramFilterViewModel {
    
    // MARK: - View Model
    private var programListViewModel: ProgramListViewModel?
    
    enum SectionType {
        case slider
        case switchControl
    }
    
    // MARK: - Variables
    var title: String = "Filter"
    
    private let sliderTitles = [FilterTitles(title: "", subtitle: "Select Trader Level"),
                                FilterTitles(title: "", subtitle: "Select Average Profit"),
                                FilterTitles(title: "", subtitle: "Select Total Profit"),
                                FilterTitles(title: "", subtitle: "Select Balance")]
    
    private let switchTitles = [FilterTitles(title: "", subtitle: "Active programs only"),
                                FilterTitles(title: "", subtitle: "Favorite programs only"),
                                FilterTitles(title: "", subtitle: "Available to invest only")]
    
    private var sections: [SectionType] = [.slider, .switchControl]
    
    private var sliderRows: [SliderType] = [.level, .avgProfit, .totalProfit, .balance]
    private var switchRows: [SwitchType] = [.activePrograms]
    
    private var router: ProgramFilterRouter!
    
    private var filter: ProgramsFilter?
    
    var sliderCellModels = [FilterSliderTableViewCellViewModel]()
    var switchCellModels = [FilterSwitchTableViewCellViewModel]()
    
    weak var sliderDelegate: TTRangeSliderDelegate?
    weak var switchDelegate: FilterSwitchTableViewCellProtocol?
    
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [FilterSliderTableViewCellViewModel.self, FilterSwitchTableViewCellViewModel.self]
    }
    
    // MARK: - Init
    init(withRouter router: ProgramFilterRouter,
         programListViewModel: ProgramListViewModel) {
        
        self.router = router
        self.programListViewModel = programListViewModel
        
        if let filter = programListViewModel.filter {
            self.filter = ProgramsFilter(managerId: filter.managerId,
                                                   brokerId: filter.brokerId,
                                                   brokerTradeServerId: filter.brokerTradeServerId,
                                                   investMaxAmountFrom: filter.investMaxAmountFrom,
                                                   investMaxAmountTo: filter.investMaxAmountTo,
                                                   sorting: filter.sorting,
                                                   name: filter.name,
                                                   levelMin: filter.levelMin,
                                                   levelMax: filter.levelMax,
                                                   balanceUsdMin: filter.balanceUsdMin,
                                                   balanceUsdMax: filter.balanceUsdMax,
                                                   profitAvgMin: filter.profitAvgMin,
                                                   profitAvgMax: filter.profitAvgMax,
                                                   profitTotalMin: filter.profitTotalMin,
                                                   profitTotalMax: filter.profitTotalMax,
                                                   profitTotalPercentMin: filter.profitTotalPercentMin,
                                                   profitTotalPercentMax: filter.profitTotalPercentMax,
                                                   profitAvgPercentMin: filter.profitAvgPercentMin,
                                                   profitAvgPercentMax: filter.profitAvgPercentMax,
                                                   profitTotalChange: filter.profitTotalChange,
                                                   periodMin: filter.periodMin,
                                                   periodMax: filter.periodMax,
                                                   showActivePrograms: filter.showActivePrograms,
                                                   equityChartLength: filter.equityChartLength,
                                                   showMyFavorites: filter.showMyFavorites,
                                                   roundNumber: filter.roundNumber,
                                                   skip: filter.skip,
                                                   take: filter.take)
        }
    }
    
    func setup(sliderDelegate: TTRangeSliderDelegate?, switchDelegate: FilterSwitchTableViewCellProtocol?) {
        self.sliderDelegate = sliderDelegate
        self.switchDelegate = switchDelegate
        setup()
    }
    
    // MARK: - Public methods
    func updateFilter(levelMin: Int? = nil, levelMax: Int? = nil,
                      profitAvgPercentMin: Double? = nil, profitAvgPercentMax: Double? = nil,
                      profitTotalMin: Double? = nil, profitTotalMax: Double? = nil,
                      balanceMin: Double? = nil, balanceMax: Double? = nil,
                      showActivePrograms: Bool? = nil,
                      showMyFavorites: Bool? = nil,
                      showAvailableToInvest: Bool? = nil) {
        
        if let showMyFavorites = showMyFavorites {
            filter?.showMyFavorites = showMyFavorites
        }
        
        if let showActivePrograms = showActivePrograms {
            filter?.showActivePrograms = showActivePrograms
        }
        
        if let showAvailableToInvest = showAvailableToInvest {
            print(showAvailableToInvest)
            //TODO:
//            filter?.showAvailableToInvest = showAvailableToInvest
        }
        
        if let levelMin = levelMin, let levelMax = levelMax {
            filter?.levelMin = levelMin == PlatformManager.filterConstants.minLevel ? nil : levelMin
            filter?.levelMax = levelMax == PlatformManager.filterConstants.maxLevel ? nil : levelMax
        }
        
        if let profitAvgPercentMin = profitAvgPercentMin, let profitAvgPercentMax = profitAvgPercentMax {
            filter?.profitAvgPercentMin = profitAvgPercentMin == PlatformManager.filterConstants.minAvgProfit ? nil : profitTotalMin
            filter?.profitAvgPercentMax = profitAvgPercentMax == PlatformManager.filterConstants.maxAvgProfit ? nil : profitTotalMin
        }
        
        if let profitTotalMin = profitTotalMin, let profitTotalMax = profitTotalMax {
            filter?.profitTotalMin = profitTotalMin == PlatformManager.filterConstants.minTotalProfit ? nil : profitTotalMin
            filter?.profitTotalMax = profitTotalMax == PlatformManager.filterConstants.maxTotalProfit ? nil : profitTotalMax
        }
        
        if let balanceMin = balanceMin, let balanceMax = balanceMax {
            filter?.balanceUsdMin = balanceMin == PlatformManager.filterConstants.minUsdBalance ? nil : balanceMin
            filter?.balanceUsdMax = balanceMax == PlatformManager.filterConstants.maxUsdBalance ? nil : balanceMax
        }
    }
    
    /// Get TableViewCellViewModel for IndexPath
    func model(for indexPath: IndexPath) -> CellViewAnyModel {
        let type = sections[indexPath.section]
        switch type {
        case .slider:
            return sliderCellModels[indexPath.row]
        case .switchControl:
            return switchCellModels[indexPath.row]
        }
    }
    
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        switch sections[section] {
        case .slider:
            return sliderCellModels.count
        case .switchControl:
            return AuthManager.isLogin() ? switchCellModels.count : switchCellModels.count - 1
        }
    }
    
    func reset() {
        for idx in 0...sliderRows.count - 1 {
            var viewModel = sliderCellModels[idx]
            
            switch sliderRows[idx] {
            case .level:
                viewModel.selectedMinValue = Double(PlatformManager.filterConstants.minLevel)
                viewModel.selectedMaxValue = Double(PlatformManager.filterConstants.maxLevel)
                updateFilter(levelMin: PlatformManager.filterConstants.minLevel, levelMax: PlatformManager.filterConstants.maxLevel)
            case .avgProfit:
                viewModel.selectedMinValue = PlatformManager.filterConstants.minAvgProfit
                viewModel.selectedMaxValue = PlatformManager.filterConstants.maxAvgProfit
                updateFilter(profitAvgPercentMin: PlatformManager.filterConstants.minAvgProfit, profitAvgPercentMax: PlatformManager.filterConstants.maxAvgProfit)
            case .totalProfit:
                viewModel.selectedMinValue = PlatformManager.filterConstants.minTotalProfit
                viewModel.selectedMaxValue = PlatformManager.filterConstants.maxTotalProfit
                updateFilter(profitTotalMin: PlatformManager.filterConstants.minTotalProfit, profitTotalMax: PlatformManager.filterConstants.maxTotalProfit)
            case .balance:
                viewModel.selectedMinValue = PlatformManager.filterConstants.minUsdBalance
                viewModel.selectedMaxValue = PlatformManager.filterConstants.maxUsdBalance
                updateFilter(balanceMin: PlatformManager.filterConstants.minUsdBalance, balanceMax: PlatformManager.filterConstants.maxUsdBalance)
            }
            
            sliderCellModels[idx] = viewModel
        }
        
        for idx in 0...switchRows.count - 1 {
            var viewModel = switchCellModels[idx]
            
            switch switchRows[idx] {
            case .activePrograms:
                filter?.showActivePrograms = PlatformManager.filterConstants.showActivePrograms
                viewModel.isOn = filter?.showActivePrograms
            case .favoritePrograms:
                filter?.showMyFavorites = PlatformManager.filterConstants.showMyFavorites
                viewModel.isOn = filter?.showMyFavorites
            case .availableToInvest:
                break
            }
            
            switchCellModels[idx] = viewModel
        }
    }
    
    func apply(completion: @escaping CompletionBlock) {
        programListViewModel?.filter = filter

        programListViewModel?.refresh(completion: completion)
    }
    
    func goToBack() {
        router.goToBack()
    }
    
    // MARK: - Private methods
    private func setup() {
        for idx in 0...sliderRows.count - 1 {
            var sliderCellModel: FilterSliderTableViewCellViewModel?
            
            let titles = sliderTitles[idx]
            let type = sliderRows[idx]
            
            let formatter = NumberFormatter()
            
            switch type {
            case .level:
                var selectedLevelMin: Double?
                if let levelMin = filter?.levelMin {
                    selectedLevelMin = Double(levelMin)
                }
                
                var selectedLevelMax: Double?
                if let levelMax = filter?.levelMax {
                    selectedLevelMax = Double(levelMax)
                }
                
                sliderCellModel = FilterSliderTableViewCellViewModel(minValue: Double(PlatformManager.filterConstants.minLevel), maxValue: Double(PlatformManager.filterConstants.maxLevel), filterTitles: titles, amountType: type, selectedMinValue: selectedLevelMin, selectedMaxValue: selectedLevelMax, customFormatter: nil, sliderViewTag: idx, delegate: sliderDelegate)
            case .avgProfit:
                formatter.positiveSuffix = "%"
                formatter.negativeSuffix = "%"
                formatter.numberStyle = .decimal
                formatter.maximumFractionDigits = 0
                sliderCellModel = FilterSliderTableViewCellViewModel(minValue: PlatformManager.filterConstants.minAvgProfit, maxValue: PlatformManager.filterConstants.maxAvgProfit, filterTitles: titles, amountType: type, selectedMinValue: filter?.profitAvgPercentMin, selectedMaxValue: filter?.profitAvgPercentMax, customFormatter: formatter, sliderViewTag: idx, delegate: sliderDelegate)
            case .totalProfit:
                formatter.positiveSuffix = " GVT"
                formatter.negativeSuffix = " GVT"
                formatter.numberStyle = .decimal
                formatter.maximumFractionDigits = 0
                sliderCellModel = FilterSliderTableViewCellViewModel(minValue: PlatformManager.filterConstants.minTotalProfit, maxValue: PlatformManager.filterConstants.maxTotalProfit, filterTitles: titles, amountType: type, selectedMinValue: filter?.profitTotalMin, selectedMaxValue: filter?.profitTotalMax, customFormatter: formatter, sliderViewTag: idx, delegate: sliderDelegate)
            case .balance:
                formatter.numberStyle = .currency
                formatter.locale = Locale(identifier: "en_US")
                formatter.maximumFractionDigits = 0
                formatter.maximumIntegerDigits = 2
                formatter.maximumSignificantDigits = 2
                sliderCellModel = FilterSliderTableViewCellViewModel(minValue: PlatformManager.filterConstants.minUsdBalance, maxValue: PlatformManager.filterConstants.maxUsdBalance, filterTitles: titles, amountType: type, selectedMinValue: filter?.balanceUsdMin, selectedMaxValue: filter?.balanceUsdMax, customFormatter: formatter, sliderViewTag: idx, delegate: sliderDelegate)
            }
            
            sliderCellModels.append(sliderCellModel!)
        }
        
        for idx in 0...switchRows.count - 1 {
            var switchCellModel: FilterSwitchTableViewCellViewModel?
            
            let titles = switchTitles[idx]
            let type = switchRows[idx]
            
            switch type {
            case .activePrograms:
                switchCellModel = FilterSwitchTableViewCellViewModel(filterTitles: titles, isOn: filter?.showActivePrograms, switchViewTag: idx, delegate: switchDelegate)
            case .favoritePrograms:
                switchCellModel = FilterSwitchTableViewCellViewModel(filterTitles: titles, isOn: filter?.showMyFavorites, switchViewTag: idx, delegate: switchDelegate)
            case .availableToInvest:
                break
            }
            
            switchCellModels.append(switchCellModel!)
        }
    }
}
