//
//  FilterViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 31.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

final class FilterViewModel {
    
    // MARK: - View Model
    enum SectionType {
        case common
    }
    
    enum RowType {
        case levels
        case currency
        case sort
        case dateRange
    }
    
    // MARK: - Variables
    var title: String = "Filters"
    
    private var sections: [SectionType] = [.common]
    
    private var rows: [RowType] = [.levels, .currency, .sort, .dateRange]
    
    private var router: ProgramFilterRouter!
    
    var viewModels = [FilterTableViewCellViewModel]()
    
    var sortingDelegateManager: SortingDelegateManager!
    
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [FilterTableViewCellViewModel.self]
    }
    
    // MARK: - Init
    init(withRouter router: ProgramFilterRouter, sortingType: SortingType) {
        
        self.router = router
        setup()
        sortingDelegateManager = SortingDelegateManager(sortingType)
    }
    
    
    // MARK: - Public methods
    
    /// Get TableViewCellViewModel for IndexPath
    func model(for indexPath: IndexPath) -> CellViewAnyModel {
        let type = sections[indexPath.section]
        switch type {
        case .common:
            return viewModels[indexPath.row]
        }
    }
    
    func getRowType(for indexPath: IndexPath) -> RowType {
        return rows[indexPath.row]
    }
    
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        switch sections[section] {
        case .common:
            return rows.count
        }
    }
    
    func reset() {
        
    }
    
    func apply(completion: @escaping CompletionBlock) {
        completion(.success)
    }
    
    func goToBack() {
        router.goToBack()
    }
    
    // MARK: - Private methods
    private func setup() {
        var tableViewCellViewModel = FilterTableViewCellViewModel(title: "Levels", detail: nil)
        viewModels.append(tableViewCellViewModel)
        
        tableViewCellViewModel = FilterTableViewCellViewModel(title: "Currency", detail: nil)
        viewModels.append(tableViewCellViewModel)
        
        tableViewCellViewModel = FilterTableViewCellViewModel(title: "Sort", detail: nil)
        viewModels.append(tableViewCellViewModel)
        
        tableViewCellViewModel = FilterTableViewCellViewModel(title: "Date Range", detail: nil)
        viewModels.append(tableViewCellViewModel)
    }
}
