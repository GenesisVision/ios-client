//
//  FilterViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 31.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

class FilterViewModel {
    
    enum SectionType {
        case amount
        case sort
    }
    
    // MARK: - Variables
    var title: String = "Filter"
    
    private var sections: [SectionType] = []
    private var router: FilterRouter!
    private var filterModel: InvestmentsFilter?
    private var sorting: [String] = []
    
    // MARK: - Init
    init(withRouter router: FilterRouter, withSorting sorting: [String]? = nil) {
        self.router = router
        self.sorting = sorting ?? []
        
        setup()
    }
    
    // MARK: - Public methods
    func model(for indexPath: IndexPath) -> CellViewAnyModel {
        let type = sections[indexPath.section]
        switch type {
        case .amount:
            return FilterAmountTableViewCellViewModel(minValue: 0.0, maxValue: 1000.0, selectedMinimum: 0.0, selectedMaximum: 1000.0, step: 50.0)
        case .sort:
            var sorting: [String] = []
            InvestmentsFilter.Sorting.cases().forEach({ (sort) in
                sorting.append(sort.rawValue)
            })
            
            return FilterSortTableViewCellViewModel(sorting: sorting)
        }
    }
    
    func registerNibs() -> [CellViewAnyModel.Type] {
        return [FilterAmountTableViewCellViewModel.self, FilterSortTableViewCellViewModel.self]
    }
    
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfRowsIn(section: Int) -> Int {
        switch sections[section] {
        case .amount, .sort:
            return 1
        }
    }
    
    func reset() {
        
    }
    
    func apply() {
        
    }
    
    func updateFilter(managerId: UUID? = nil,
                      brokerId: UUID? = nil,
                      brokerTradeServerId: UUID? = nil,
                      investMaxAmountFrom: Double? = nil,
                      investMaxAmountTo: Double? = nil,
                      sorting: InvestmentsFilter.Sorting? = nil,
                      skip: Int? = nil,
                      take: Int? = nil) {
        filterModel = InvestmentsFilter(managerId: managerId,
                                        brokerId: brokerId,
                                        brokerTradeServerId: brokerTradeServerId,
                                        investMaxAmountFrom: investMaxAmountFrom,
                                        investMaxAmountTo: investMaxAmountTo,
                                        sorting: sorting,
                                        skip: skip,
                                        take: take)
    }
    
    // MARK: - Private methods
    
    private func setup() {
        sections.append(contentsOf: [.amount, .sort])
    }
}



