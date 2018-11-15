//
//  FilterViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 31.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import UIKit

protocol FilterViewModelProtocol: class {
    func didFilterReloadCell(_ row: Int)
}

final class FilterViewModel {
    
    // MARK: - View Model
    private var listViewModel: ListViewModelProtocol?
    
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
    
    var sortingDelegateManager: SortingDelegateManager?
    var currencyDelegateManager: FilterCurrencyDelegateManager?
    var levelsFilterView: LevelsFilterView?
    var dateRangeView: DateRangeView?
    
    private weak var filterViewModelProtocol: FilterViewModelProtocol?
    
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [FilterTableViewCellViewModel.self]
    }
    
    // MARK: - Init
    init(withRouter router: ProgramFilterRouter, sortingType: SortingType, filterViewModelProtocol: FilterViewModelProtocol?) {
        
        self.router = router
        self.filterViewModelProtocol = filterViewModelProtocol

        sortingDelegateManager = SortingDelegateManager(sortingType)
        sortingDelegateManager?.delegate = self
        currencyDelegateManager = FilterCurrencyDelegateManager()
        currencyDelegateManager?.loadCurrencies()
        currencyDelegateManager?.delegate = self
        levelsFilterView = LevelsFilterView.viewFromNib()
        levelsFilterView?.delegate = self
        
        setup()
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
        currencyDelegateManager?.reset()
        sortingDelegateManager?.reset()
        levelsFilterView?.reset()
        dateRangeView?.reset()
        
        viewModels[0].detail = levelsFilterView?.getSelectedLevels()
        
        if let detail =
            currencyDelegateManager?.getSelectedCurrencyValue() {
            viewModels[1].detail = detail
        }
    
        if let detail = sortingDelegateManager?.sortingManager?.getSelectedSortingValue() {
            viewModels[2].detail = "by " + detail
        }
        
        
        if let selectedDate = getSelectedDate() {
            viewModels[3].detail = selectedDate
        }
    }
    
    func apply(completion: @escaping CompletionBlock) {
        if let minLevel = levelsFilterView?.minLevel, let maxLevel = levelsFilterView?.maxLevel {
            listViewModel?.minLevel = minLevel
            listViewModel?.maxLevel = maxLevel
        }
        
        if let dateRangeView = dateRangeView {
            PlatformManager.shared.dateFrom = dateRangeView.dateFrom
            PlatformManager.shared.dateTo = dateRangeView.dateTo
            PlatformManager.shared.dateRangeType = dateRangeView.selectedDateRangeType
        }
        
        completion(.success)
    }
    
    func goToBack() {
        router.goToBack()
    }
    
    // MARK: - Private methods
    private func setup() {
        var tableViewCellViewModel = FilterTableViewCellViewModel(title: "Levels", detail: nil)
        tableViewCellViewModel.detail = levelsFilterView?.getSelectedLevels()
        
        viewModels.append(tableViewCellViewModel)
        
        tableViewCellViewModel = FilterTableViewCellViewModel(title: "Currency", detail: nil)
        if let selectedValue = currencyDelegateManager?.getSelectedCurrencyValue() {
            tableViewCellViewModel.detail = selectedValue
        }
        viewModels.append(tableViewCellViewModel)
        
        tableViewCellViewModel = FilterTableViewCellViewModel(title: "Sort", detail: nil)
        if let selectedValue = sortingDelegateManager?.sortingManager?.getSelectedSortingValue() {
            tableViewCellViewModel.detail = "by " + selectedValue.capitalized
        }
        viewModels.append(tableViewCellViewModel)
        
        
        tableViewCellViewModel = FilterTableViewCellViewModel(title: "Date Range", detail: nil)
        
        if let selectedValue = getSelectedDate() {
            tableViewCellViewModel.detail = selectedValue
        }
            
        viewModels.append(tableViewCellViewModel)
    }
    
    private func getSelectedDate() -> String? {
        var selectedDate = ""
        let dateRangeType = PlatformManager.shared.dateRangeType
        
        switch dateRangeType {
        case .custom:
            guard let dateFrom = PlatformManager.shared.dateFrom, let dateTo = PlatformManager.shared.dateTo else { return nil }
            
            let title = Date.getFormatStringForChart(for: dateFrom, dateRangeType: dateRangeType) + "-" + Date.getFormatStringForChart(for: dateTo, dateRangeType: dateRangeType)
            selectedDate = title
        default:
            selectedDate = dateRangeType.getString()
        }
        
        return selectedDate
    }
}

extension FilterViewModel: LevelsFilterViewProtocol {
    func applyButtonDidPress() {
        viewModels[0].detail = levelsFilterView?.getSelectedLevels()
        
        filterViewModelProtocol?.didFilterReloadCell(0)
    }
    
    func showPickerMinPicker(min minLevel: Int, max maxLevel: Int) {
        guard let vc = router.currentController as? BaseViewController else { return }
        
        let alert = UIAlertController(style: .actionSheet, title: nil, message: nil)
        alert.view.tintColor = UIColor.Cell.headerBg
        
        var values: [String] = []
        for idx in Filters.minLevel...Filters.maxLevel - 1 {
            values.append("\(idx)")
        }
        
        var minValue = 1
        if let text = self.levelsFilterView?.minTextField.text, let min = Int(text) {
            minValue = min
        }
        let selectedIndex = values.index{ $0 == "\(minValue)" } ?? 0
        
        let pickerViewValues: [[String]] = [values.map { $0 }]
        
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: selectedIndex)
        
        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { [weak self] vc, picker, index, values in
            if let minSelectedValue = Int(values[index.column][index.row]) {
                if let text = self?.levelsFilterView?.maxTextField.text, let maxValue = Int(text), minSelectedValue > maxValue {
                    self?.levelsFilterView?.maxTextField.text = "\(minSelectedValue + 1)"
                }
                self?.levelsFilterView?.minTextField.text = "\(minSelectedValue)"
            }
        }
        
        alert.addAction(title: "Done", style: .cancel)
        vc.bottomSheetController.present(viewController: alert)
    }
    
    func showPickerMaxPicker(min minLevel: Int, max maxLevel: Int) {
        guard let vc = router.currentController as? BaseViewController else { return }
        
        let alert = UIAlertController(style: .actionSheet, title: nil, message: nil)
        alert.view.tintColor = UIColor.Cell.headerBg
        
        var values: [String] = []
        var minValue = 1
        if let text = self.levelsFilterView?.minTextField.text, let min = Int(text) {
            minValue = min
        }
            
        for idx in (minValue + 1)...Filters.maxLevel {
            values.append("\(idx)")
        }
        
        var maxValue = 7
        if let text = self.levelsFilterView?.maxTextField.text, let max = Int(text) {
            maxValue = max
        }
        let selectedIndex = values.index{ $0 == "\(maxValue)" } ?? 0
        
        let pickerViewValues: [[String]] = [values.map { $0 }]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: selectedIndex)
        
        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { [weak self] vc, picker, index, values in
            self?.levelsFilterView?.maxTextField.text = values[index.column][index.row]
        }
        
        alert.addAction(title: "Done", style: .cancel)
        vc.bottomSheetController.present(viewController: alert)
    }
}

extension FilterViewModel: FilterCurrencyDelegateManagerProtocol {
    func didSelectFilterCurrency(at indexPath: IndexPath) {
        if let detail =
            currencyDelegateManager?.getSelectedCurrencyValue() {
            viewModels[1].detail = detail
        }
        
        filterViewModelProtocol?.didFilterReloadCell(1)
    }
}

extension FilterViewModel: SortingDelegate {
    func didSelectSorting() {
        if let detail = sortingDelegateManager?.sortingManager?.getSelectedSortingValue() {
            viewModels[2].detail = "by " + detail
        }
        
        filterViewModelProtocol?.didFilterReloadCell(2)
    }
}

extension FilterViewModel: DateRangeViewProtocol {
    func showDatePicker(from dateFrom: Date?, to dateTo: Date) {
        
    }
    
    func applyButtonDidPress(from dateFrom: Date?, to dateTo: Date?) {
        if let selectedDate = getSelectedDate() {
            viewModels[3].detail = selectedDate
        }
        
        filterViewModelProtocol?.didFilterReloadCell(3)
    }
}
