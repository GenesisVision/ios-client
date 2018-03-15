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
    private weak var investmentProgramListViewModel: InvestmentProgramListViewModel?
    
    enum SectionType {
        case slider
        case sort
    }
    
    // MARK: - Variables
    var title: String = "Filter"
    
    private let amountsTitles = [AmountTitles(title: "Level", subtitle: "Select Trader Level"),
                                 AmountTitles(title: "Total Profit", subtitle: "Select Trader Total Profit"),
                                 AmountTitles(title: "Average Profit", subtitle: "Select Trader Profit")]
    
    private var amounts: [AmountType] = [.level, .totalProfit, .averageProfit]
    private var sections: [SectionType] = [.slider, .sort]
    private var router: ProgramFilterRouter!
    private var sortingList: [InvestmentProgramsFilter.Sorting : String] = [.byLevelAsc : "Level ⇡",
                                                                     .byLevelDesc : "Level ⇣",
                                                                     .byOrdersAsc : "Orders ⇡",
                                                                     .byOrdersDesc : "Orders ⇣",
                                                                     .byProfitAsc : "Profit ⇡",
                                                                     .byProfitDesc : "Profit ⇣",
                                                                     .byEndOfPeriodAsk : "End of period ⇡",
                                                                     .byEndOfPeriodDesc : "End of period ⇣"]
    
    var filter: InvestmentProgramsFilter?
    
    var amountCellModels = [FilterAmountTableViewCellViewModel]()
    var amountCellModel: FilterAmountTableViewCellViewModel?
    var sortCellModels = [FilterSortTableViewCellViewModel]()
    
    weak var sliderDelegate: TTRangeSliderDelegate?
//        {
//        didSet {
//            amountCellModels.delegate = sliderDelegate
//        }
//    }
    
    /// Return view models for registration cell Nib files
    static var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [FilterAmountTableViewCellViewModel.self,
                FilterSortTableViewCellViewModel.self]
    }
    
    // MARK: - Init
    init(withRouter router: ProgramFilterRouter,
         investmentProgramListViewModel: InvestmentProgramListViewModel) {
        
        self.router = router
        self.investmentProgramListViewModel = investmentProgramListViewModel
        
        if let filter = investmentProgramListViewModel.filter {
            self.filter = filter
        }
        
        setup()
    }
    
    // MARK: - Public methods
    
    /// Get TableViewCellViewModel for IndexPath
    func model(for indexPath: IndexPath) -> CellViewAnyModel {
        let type = sections[indexPath.section]
        switch type {
        case .slider:
            return amountCellModels[indexPath.row]
        case .sort:
            return sortCellModels[indexPath.row]
        }
    }
    
    func select(for indexPath: IndexPath) {
        for idx in 0...sortCellModels.count - 1 {
            sortCellModels[idx].selected = idx == indexPath.row ? !sortCellModels[idx].selected : false
        }
        
        filter?.sorting = sortCellModels[indexPath.row].selected ? InvestmentProgramsFilter.Sorting(rawValue: sortCellModels[indexPath.row].sorting.type)! : InvestmentProgramsFilter.Sorting.byProfitAsc
    }
    
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        switch sections[section] {
        case .slider:
            return amountCellModels.count
        case .sort:
            return sortCellModels.count
        }
    }
    
    func reset() {
        filter?.sorting = InvestmentProgramsFilter.Sorting.byProfitAsc
        
        for idx in 0...amounts.count - 1 {
            var viewModel = amountCellModels[idx]
            
            switch amounts[idx] {
            case .level:
                viewModel.selectedMinValue = filter?.levelMin
                viewModel.selectedMaxValue = filter?.levelMax
            case .totalProfit:
                viewModel.selectedMinValue = filter?.profitTotalMin
                viewModel.selectedMaxValue = filter?.profitTotalMax
            case .averageProfit:
                viewModel.selectedMinValue = filter?.profitAvgPercentMin
                viewModel.selectedMaxValue = filter?.profitAvgPercentMax
            }
        }
        
        investmentProgramListViewModel?.filter = filter
        
        for idx in 0...sortCellModels.count - 1 {
            sortCellModels[idx].selected = false
        }
        
        sortCellModels[0].selected = true
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
        for idx in 0...amounts.count - 1 {
            var amountCellModel: FilterAmountTableViewCellViewModel?
            
            let titles = amountsTitles[idx]
            let type = amounts[idx]
            
            switch type {
            case .level:
                amountCellModel = FilterAmountTableViewCellViewModel(minValue: 1, maxValue: 7, amountTitles: titles, amountType: type, selectedMinValue: filter?.levelMin, selectedMaxValue: filter?.levelMax, delegate: nil)
            case .totalProfit:
                amountCellModel = FilterAmountTableViewCellViewModel(minValue: nil, maxValue: nil, amountTitles: titles, amountType: type, selectedMinValue: filter?.profitTotalMin, selectedMaxValue: filter?.profitTotalMax, delegate: nil)
            case .averageProfit:
                amountCellModel = FilterAmountTableViewCellViewModel(minValue: nil, maxValue: nil, amountTitles: titles, amountType: type, selectedMinValue: filter?.profitAvgPercentMin, selectedMaxValue: filter?.profitAvgPercentMax, delegate: nil)
            }
        
            amountCellModels.append(amountCellModel!)
        }
        
        sortingList.forEach { (dict) in
            sortCellModels.append(FilterSortTableViewCellViewModel(sorting: SortField(type: dict.key.rawValue, text: dict.value), selected: dict.key == filter?.sorting))
        }
        
        sortCellModels.sort(by: {$0.sorting.text < $1.sorting.text})
    }
}

