//
//  ProgramFilterViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 31.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import TTRangeSlider

enum SliderType: Int {
    case level, avgProfit
}

enum SwitchType: Int {
    case activePrograms, favoritePrograms
}


final class ProgramFilterViewModel {
    
    // MARK: - View Model
    private var investmentProgramListViewModel: InvestmentProgramListViewModel?
    
    enum SectionType {
        case slider
        case switchControl
    }
    
    // MARK: - Variables
    var title: String = "Filter"
    
    private let sliderTitles = [FilterTitles(title: "", subtitle: "Select Trader Level"),
                                 FilterTitles(title: "", subtitle: "Select Trader Profit %")]
    
    private let switchTitles = [FilterTitles(title: "", subtitle: "Only active programs"),
                                FilterTitles(title: "", subtitle: "Only favorite programs")]
    
    private var sections: [SectionType] = [.slider, .switchControl]
    
    private var sliderRows: [SliderType] = [.level, .avgProfit]
    private var switchRows: [SwitchType] = [.activePrograms, .favoritePrograms]
    
    private var router: ProgramFilterRouter!
    
    private var filter: InvestmentProgramsFilter?
    
    var sliderCellModels = [FilterSliderTableViewCellViewModel]()
    var switchCellModels = [FilterSwitchTableViewCellViewModel]()
    
    weak var sliderDelegate: TTRangeSliderDelegate?
    weak var switchDelegate: FilterSwitchTableViewCellProtocol?
    
    /// Return view models for registration cell Nib files
    static var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [FilterSliderTableViewCellViewModel.self, FilterSwitchTableViewCellViewModel.self]
    }
    
    // MARK: - Init
    init(withRouter router: ProgramFilterRouter,
         investmentProgramListViewModel: InvestmentProgramListViewModel) {
        
        self.router = router
        self.investmentProgramListViewModel = investmentProgramListViewModel
        
        if let filter = investmentProgramListViewModel.filter {
            self.filter = InvestmentProgramsFilter(managerId: filter.managerId,
                                                   brokerId: filter.brokerId,
                                                   brokerTradeServerId: filter.brokerTradeServerId,
                                                   investMaxAmountFrom: filter.investMaxAmountFrom,
                                                   investMaxAmountTo: filter.investMaxAmountTo,
                                                   sorting: filter.sorting,
                                                   name: filter.name,
                                                   levelMin: filter.levelMin,
                                                   levelMax: filter.levelMax,
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
    func updateFilter(levelMin: Int? = nil, levelMax: Int? = nil, profitTotalMin: Int? = nil, profitTotalMax: Int? = nil, profitAvgPercentMin: Int? = nil, profitAvgPercentMax: Int? = nil, showActivePrograms: Bool? = nil, showMyFavorites: Bool? = nil) {
        
        if let showMyFavorites = showMyFavorites {
            filter?.showMyFavorites = showMyFavorites
        }
        if let showActivePrograms = showActivePrograms {
            filter?.showActivePrograms = showActivePrograms
        }
        
        if let levelMin = levelMin, let levelMax = levelMax {
            filter?.levelMin = levelMin
            filter?.levelMax = levelMax
        }
        
        if let profitTotalMin = profitTotalMin, let profitTotalMax = profitTotalMax {
            filter?.profitTotalMin = profitTotalMin
            filter?.profitTotalMax = profitTotalMax
        }
        
        if let profitAvgPercentMin = profitAvgPercentMin, let profitAvgPercentMax = profitAvgPercentMax {
            filter?.profitAvgPercentMin = profitAvgPercentMin
            filter?.profitAvgPercentMax = profitAvgPercentMax
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
                filter?.levelMin = Constants.Filters.minLevel
                filter?.levelMax = Constants.Filters.maxLevel
                viewModel.selectedMinValue = filter?.levelMin
                viewModel.selectedMaxValue = filter?.levelMax
            case .avgProfit:
                filter?.profitAvgPercentMin = Constants.Filters.minAvgProfit
                filter?.profitAvgPercentMax = Constants.Filters.maxAvgProfit
                viewModel.selectedMinValue = filter?.profitAvgPercentMin
                viewModel.selectedMaxValue = filter?.profitAvgPercentMax
            }
            
            sliderCellModels[idx] = viewModel
        }
        
        for idx in 0...switchRows.count - 1 {
            var viewModel = switchCellModels[idx]
            
            switch switchRows[idx] {
            case .activePrograms:
                filter?.showActivePrograms = Constants.Filters.showActivePrograms
                viewModel.isOn = filter?.showActivePrograms
            case .favoritePrograms:
                filter?.showMyFavorites = Constants.Filters.showMyFavorites
                viewModel.isOn = filter?.showMyFavorites
            }
            
            switchCellModels[idx] = viewModel
        }
    }
    
    func apply(completion: @escaping CompletionBlock) {
        investmentProgramListViewModel?.filter = filter

        investmentProgramListViewModel?.refresh(completion: completion)
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
            
            switch type {
            case .level:
                sliderCellModel = FilterSliderTableViewCellViewModel(minValue: Constants.Filters.minLevel, maxValue: Constants.Filters.maxLevel, filterTitles: titles, amountType: type, selectedMinValue: filter?.levelMin, selectedMaxValue: filter?.levelMax, sliderViewTag: idx, delegate: sliderDelegate)
            case .avgProfit:
                sliderCellModel = FilterSliderTableViewCellViewModel(minValue: Constants.Filters.minAvgProfit, maxValue: Constants.Filters.maxAvgProfit, filterTitles: titles, amountType: type, selectedMinValue: filter?.profitAvgPercentMin, selectedMaxValue: filter?.profitAvgPercentMax, sliderViewTag: idx, delegate: sliderDelegate)
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
            }
            
            switchCellModels.append(switchCellModel!)
        }
    }
}
