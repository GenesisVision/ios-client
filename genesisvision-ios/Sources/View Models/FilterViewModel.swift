//
//  FilterViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 31.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

class FilterViewModel {
    
    // MARK: - View Model
    private weak var investmentProgramListViewModel: InvestmentProgramListViewModel?
    
    enum SectionType {
        case amount
        case sort
    }
    
    // MARK: - Variables
    var title: String = "Filter"
    
    private var sections: [SectionType] = []
    private var router: FilterRouter!
    private var sortingList: [String : InvestmentsFilter.Sorting] = ["Rating asc" : .byRatingAsc,
                                                                     "Rating desc" : .byRatingDesc,
                                                                     "Orders asc" : .byOrdersAsc,
                                                                     "Orders desc" : .byOrdersDesc,
                                                                     "Profit asc" : .byProfitAsc,
                                                                     "Profit desc" : .byProfitDesc]
    
    var sorting: InvestmentsFilter.Sorting?
    var investMaxAmountFrom: Double?
    var investMaxAmountTo: Double?
    
    /// Return view models for registration cell Nib files
    static var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [FilterAmountTableViewCellViewModel.self,
                FilterSortTableViewCellViewModel.self]
    }
    
    // MARK: - Init
    init(withRouter router: FilterRouter,
         investmentProgramListViewModel: InvestmentProgramListViewModel,
         sorting: InvestmentsFilter.Sorting? = nil,
         investMaxAmountFrom: Double? = nil,
         investMaxAmountTo: Double? = nil) {
        
        self.router = router
        self.investmentProgramListViewModel = investmentProgramListViewModel
        
        self.sorting = sorting
        self.investMaxAmountFrom = investMaxAmountFrom
        self.investMaxAmountTo = investMaxAmountTo
        
        setup()
    }
    
    // MARK: - Public methods
    
    /// Get TableViewCellViewModel for IndexPath
    func model(for indexPath: IndexPath) -> CellViewAnyModel {
        let type = sections[indexPath.section]
        switch type {
        case .amount:
            return FilterAmountTableViewCellViewModel(minValue: 0.0, maxValue: 1000.0, selectedMinimum: investMaxAmountFrom, selectedMaximum: investMaxAmountTo, step: 50.0)
        case .sort:
            let sortingValue = sortingListKeys()[indexPath.row]
            let selected = false
            return FilterSortTableViewCellViewModel(sorting: sortingValue, selected: selected)
        }
    }
    
    func select(for indexPath: IndexPath) {
        let sortingValue = sortingListKeys()[indexPath.row]
        let selected = true
        _ = FilterSortTableViewCellViewModel(sorting: sortingValue, selected: selected)
        // TODO: get model and update values
    }
    
    private func sortingListKeys() -> [String] {
        return Array(sortingList.keys.sorted())
    }
    
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        switch sections[section] {
        case .amount:
            return 1
        case .sort:
            return sortingList.count
        }
    }
    
    func reset() {
        investmentProgramListViewModel?.sorting = nil
        investmentProgramListViewModel?.investMaxAmountFrom = nil
        investmentProgramListViewModel?.investMaxAmountTo = nil
    }
    
    func apply() {
        investmentProgramListViewModel?.sorting = sorting
        investmentProgramListViewModel?.investMaxAmountFrom = investMaxAmountFrom
        investmentProgramListViewModel?.investMaxAmountTo = investMaxAmountTo
        router.popViewController(animated: true)
    }
    
    // MARK: - Private methods
    private func setup() {
        sections = [.amount, .sort]
    }
}



