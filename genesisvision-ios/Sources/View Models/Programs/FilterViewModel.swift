//
//  FilterViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 31.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import TTRangeSlider

class FilterViewModel {
    
    // MARK: - View Model
    private weak var investmentProgramListViewModel: InvestmentProgramListViewModel?
    
    enum SectionType {
        case amount
        case sort
    }
    
    // MARK: - Variables
    var title: String = "Filter"
    
    private var sections: [SectionType] = [.amount, .sort]
    private var router: FilterRouter!
    private var sortingList: [InvestmentsFilter.Sorting : String] = [.byRatingAsc : "Rating asc",
                                                                     .byRatingDesc : "Rating desc",
                                                                     .byOrdersAsc : "Orders asc",
                                                                     .byOrdersDesc : "Orders desc",
                                                                     .byProfitAsc : "Profit asc",
                                                                     .byProfitDesc : "Profit desc"]
    
    var selectedSorting: InvestmentsFilter.Sorting = .byOrdersAsc
    var investMaxAmountFrom: Double?
    var investMaxAmountTo: Double?
    
    var amountCellModel: FilterAmountTableViewCellViewModel!
    var sortCellModels = [FilterSortTableViewCellViewModel]()
    
    weak var sliderDelegate: TTRangeSliderDelegate? {
        didSet {
            amountCellModel.delegate = sliderDelegate
        }
    }
    
    /// Return view models for registration cell Nib files
    static var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [FilterAmountTableViewCellViewModel.self,
                FilterSortTableViewCellViewModel.self]
    }
    
    // MARK: - Init
    init(withRouter router: FilterRouter,
         investmentProgramListViewModel: InvestmentProgramListViewModel) {
        
        self.router = router
        self.investmentProgramListViewModel = investmentProgramListViewModel
        
        self.selectedSorting = investmentProgramListViewModel.sorting
        self.investMaxAmountFrom = investmentProgramListViewModel.investMaxAmountFrom
        self.investMaxAmountTo = investmentProgramListViewModel.investMaxAmountTo
        
        setup()
    }
    
    // MARK: - Public methods
    
    /// Get TableViewCellViewModel for IndexPath
    func model(for indexPath: IndexPath) -> CellViewAnyModel {
        let type = sections[indexPath.section]
        switch type {
        case .amount:
            return amountCellModel
        case .sort:
            return sortCellModels[indexPath.row]
        }
    }
    
    func select(for indexPath: IndexPath) {
        for idx in 0...sortCellModels.count - 1 {
            sortCellModels[idx].selected = idx == indexPath.row ? !sortCellModels[idx].selected : false
        }
        
        selectedSorting = sortCellModels[indexPath.row].selected ? InvestmentsFilter.Sorting(rawValue: sortCellModels[indexPath.row].sorting.type)! : InvestmentsFilter.Sorting.byOrdersAsc
    }
    
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        switch sections[section] {
        case .amount:
            return 1
        case .sort:
            return sortCellModels.count
        }
    }
    
    func reset() {
        selectedSorting = InvestmentsFilter.Sorting.byOrdersAsc
        investMaxAmountFrom = nil
        investMaxAmountTo = nil
        
        amountCellModel.selectedMaxAmountFrom = investMaxAmountFrom
        amountCellModel.selectedMaxAmountTo = investMaxAmountTo
        
        investmentProgramListViewModel?.sorting = selectedSorting
        investmentProgramListViewModel?.investMaxAmountFrom = investMaxAmountFrom
        investmentProgramListViewModel?.investMaxAmountTo = investMaxAmountTo
        
        for idx in 0...sortCellModels.count - 1 {
            sortCellModels[idx].selected = false
        }
        
        sortCellModels[0].selected = true
    }
    
    func apply(completion: @escaping CompletionBlock) {
        investmentProgramListViewModel?.sorting = selectedSorting
        investmentProgramListViewModel?.investMaxAmountFrom = investMaxAmountFrom
        investmentProgramListViewModel?.investMaxAmountTo = investMaxAmountTo
        
        investmentProgramListViewModel?.refresh(completion: completion)
    }
    
    func popToInvestVC() {
        router.popViewController(animated: true)
    }
    
    // MARK: - Private methods
    private func setup() {
        amountCellModel = FilterAmountTableViewCellViewModel(minValue: 0.0, maxValue: 1100.0, selectedMaxAmountFrom: investMaxAmountFrom, selectedMaxAmountTo: investMaxAmountTo, step: 50.0, delegate: nil)
        
        sortingList.forEach { (dict) in
            sortCellModels.append(FilterSortTableViewCellViewModel(sorting: SortField(type: dict.key.rawValue, text: dict.value), selected: dict.key == selectedSorting))
        }
        
        sortCellModels.sort(by: {$0.sorting.text < $1.sorting.text})
    }
}
