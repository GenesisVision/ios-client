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

enum FilterType {
    case programs, funds, dashboardPrograms, dashboardFunds
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
    
    var filterType: FilterType = .programs
    
    private var sections: [SectionType] = [.common]
    
    private var rows: [RowType] = []
    
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
    init(withRouter router: ProgramFilterRouter, sortingType: SortingType, filterViewModelProtocol: FilterViewModelProtocol?, filterModel: FilterModel, listViewModel: ListViewModelProtocol?, filterType: FilterType) {
        
        self.filterType = filterType
        switch filterType {
        case .programs:
            rows = [.levels, .currency, .sort, .dateRange]
        default:
            rows = [.sort, .dateRange]
        }
        
        self.router = router
        self.filterViewModelProtocol = filterViewModelProtocol
        self.listViewModel = listViewModel
        
        setupManagers(filterModel, sortingType: sortingType)
        
        setup()
    }
    
    
    // MARK: - Public methods
    /// Get TableViewCellViewModel for IndexPath
    func model(at indexPath: IndexPath) -> CellViewAnyModel {
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
    
    func changeHighToLowValue() {
        if let sortingManager = sortingDelegateManager?.sortingManager {
            sortingManager.highToLowValue = !sortingManager.highToLowValue
        }
        
        didSelectSorting()
    }
    
    func reset() {
        currencyDelegateManager?.reset()
        sortingDelegateManager?.reset()
        levelsFilterView?.reset()
        dateRangeView?.reset()
        
        for (idx, row) in rows.enumerated() {
            switch row {
            case .levels:
                viewModels[idx].detail = levelsFilterView?.getSelectedLevels()
            case .currency:
                if let detail =
                    currencyDelegateManager?.getSelectedCurrencyValue() {
                    viewModels[idx].detail = detail
                }
            case .dateRange:
                if let selectedDate = getSelectedDate() {
                    viewModels[idx].detail = selectedDate
                }
            case .sort:
                if let detail = sortingDelegateManager?.sortingManager?.getSelectedSortingValue() {
                    viewModels[idx].detail = detail
                }
            }
        }
    }
    
    func apply(completion: @escaping CompletionBlock) {
        guard let filterModel = listViewModel?.filterModel else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        if let minLevel = levelsFilterView?.minLevel, let maxLevel = levelsFilterView?.maxLevel {
            filterModel.levelModel.minLevel = minLevel
            filterModel.levelModel.maxLevel = maxLevel
        }
        
        if let sortingManager = sortingDelegateManager?.sortingManager {
            filterModel.sortingModel.selectedIndex = sortingManager.selectedIndex
            filterModel.sortingModel.highToLowValue = sortingManager.highToLowValue
            filterModel.sortingModel.selectedSorting = sortingManager.getSelectedSorting()
        }
        
        if let currencyDelegateManager = currencyDelegateManager {
            filterModel.currencyModel.selectedIndex = currencyDelegateManager.selectedIndex
            filterModel.currencyModel.selectedCurrency = currencyDelegateManager.getSelectedCurrencyValue()
        }
        
        if let dateRangeView = dateRangeView {
            filterModel.dateRangeModel.dateFrom = dateRangeView.dateFrom
            filterModel.dateRangeModel.dateTo = dateRangeView.dateTo
            filterModel.dateRangeModel.dateRangeType = dateRangeView.dateRangeType
        }
        
        listViewModel?.refresh(completion: completion)
    }
    
    func goToBack() {
        router.goToBack()
    }
    
    // MARK: - Private methods
    private func setupManagers(_ filterModel: FilterModel, sortingType: SortingType) {
        for row in rows {
            switch row {
            case .levels:
                setupLevelsManager(filterModel)
            case .currency:
                setupCurrencyManager(filterModel)
            case .dateRange:
                setupDateRangeManager(filterModel)
            case .sort:
                setupSortingManager(filterModel, sortingType: sortingType)
            }
        }
    }
    
    private func setupLevelsManager(_ filterModel: FilterModel) {
        levelsFilterView = LevelsFilterView.viewFromNib()
        levelsFilterView?.minLevel = filterModel.levelModel.minLevel
        levelsFilterView?.maxLevel = filterModel.levelModel.maxLevel
        levelsFilterView?.delegate = self
    }
    
    private func setupCurrencyManager(_ filterModel: FilterModel) {
        currencyDelegateManager = FilterCurrencyDelegateManager()
        currencyDelegateManager?.selectedIndex = filterModel.currencyModel.selectedIndex
        currencyDelegateManager?.loadCurrencies()
        currencyDelegateManager?.delegate = self
    }
    
    private func setupDateRangeManager(_ filterModel: FilterModel) {
        dateRangeView = DateRangeView.viewFromNib()
        dateRangeView?.delegate = self
        dateRangeView?.dateFrom = filterModel.dateRangeModel.dateFrom
        dateRangeView?.dateTo = filterModel.dateRangeModel.dateTo
        dateRangeView?.dateRangeType = filterModel.dateRangeModel.dateRangeType
    }
    
    private func setupSortingManager(_ filterModel: FilterModel, sortingType: SortingType) {
        let sortingManager = SortingManager(sortingType)
        sortingDelegateManager = SortingDelegateManager(sortingManager)
        sortingDelegateManager?.delegate = self
        sortingDelegateManager?.sortingManager?.selectedIndex = filterModel.sortingModel.selectedIndex
        sortingDelegateManager?.sortingManager?.highToLowValue = filterModel.sortingModel.highToLowValue
    }
    
    private func setup() {
        var tableViewCellViewModel: FilterTableViewCellViewModel?
        
        for row in rows {
            switch row {
            case .levels:
                tableViewCellViewModel = FilterTableViewCellViewModel(title: "Levels", detail: nil, detailImage: nil)
                tableViewCellViewModel?.detail = levelsFilterView?.getSelectedLevels()
                
                viewModels.append(tableViewCellViewModel!)
            case .currency:
                tableViewCellViewModel = FilterTableViewCellViewModel(title: "Currency", detail: nil, detailImage: nil)
                
                if let selectedValue = currencyDelegateManager?.getSelectedCurrencyValue() {
                    tableViewCellViewModel?.detail = selectedValue
                }
                
                viewModels.append(tableViewCellViewModel!)
            case .dateRange:
                tableViewCellViewModel = FilterTableViewCellViewModel(title: "Date Range", detail: nil, detailImage: nil)
                
                if let selectedValue = getSelectedDate() {
                    tableViewCellViewModel?.detail = selectedValue
                }
                
                viewModels.append(tableViewCellViewModel!)
            case .sort:
                guard let highToLowValue = sortingDelegateManager?.sortingManager?.highToLowValue else { return }
                
                tableViewCellViewModel = FilterTableViewCellViewModel(title: "Sort", detail: nil, detailImage: highToLowValue ? #imageLiteral(resourceName: "img_profit_filter_icon") : #imageLiteral(resourceName: "img_profit_filter_desc_icon"))
                if let selectedValue = sortingDelegateManager?.sortingManager?.getSelectedSortingValue() {
                    tableViewCellViewModel?.detail = selectedValue
                }
                viewModels.append(tableViewCellViewModel!)
            }
        }
    }
    
    private func getSelectedDate() -> String? {
        var selectedDate = ""
        guard let dateRangeModel = listViewModel?.filterModel.dateRangeModel else { return nil }
        let dateRangeType = dateRangeModel.dateRangeType
        
        switch dateRangeType {
        case .custom:
            guard let dateFrom = dateRangeModel.dateFrom, let dateTo = dateRangeModel.dateTo else { return nil }
            
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
        let index = rows.index { $0 == .levels }
        guard let idx = index else { return }
        
        viewModels[idx].detail = levelsFilterView?.getSelectedLevels()
        
        filterViewModelProtocol?.didFilterReloadCell(idx)
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
        let index = rows.index { $0 == .currency }
        guard let idx = index else { return }
        
        if let detail =
            currencyDelegateManager?.getSelectedCurrencyValue() {
            viewModels[idx].detail = detail
        }
        
        filterViewModelProtocol?.didFilterReloadCell(idx)
    }
}

extension FilterViewModel: SortingDelegate {
    func didSelectSorting() {
        let index = rows.index { $0 == .sort }
        guard let idx = index else { return }
        
        if let sortingManager = sortingDelegateManager?.sortingManager {
            let detail = sortingManager.getSelectedSortingValue()
            let highToLowValue = sortingManager.highToLowValue
            
            viewModels[idx].detail = detail
            viewModels[idx].detailImage = highToLowValue ? #imageLiteral(resourceName: "img_profit_filter_icon") : #imageLiteral(resourceName: "img_profit_filter_desc_icon")
        }
        
        filterViewModelProtocol?.didFilterReloadCell(idx)
    }
}

extension FilterViewModel: DateRangeViewProtocol {
    var dateRange: FilterDateRangeModel? {
        get {
            return listViewModel?.filterModel.dateRangeModel
        }
        set {
            if let newValue = newValue {
                listViewModel?.filterModel.dateRangeModel = newValue
            }
        }
    }
    
    func showDatePicker(from dateFrom: Date?, to dateTo: Date) {
        guard let vc = router.currentController as? BaseViewController else { return }
        
        let alert = UIAlertController(style: .actionSheet, title: nil, message: nil)
        alert.view.tintColor = UIColor.Cell.headerBg

        if let dateFrom = dateFrom {
            alert.addDatePicker(mode: .date, date: dateFrom, minimumDate: nil, maximumDate: dateTo) { [weak self] date in
                DispatchQueue.main.async {
                    self?.dateRangeView?.dateFrom = date
                }
            }
        } else {
            alert.addDatePicker(mode: .date, date: dateTo, minimumDate: nil, maximumDate: Date()) { [weak self] date in
                DispatchQueue.main.async {
                    self?.dateRangeView?.dateTo = date
                }
            }
        }

        alert.addAction(title: "Done", style: .cancel)
        vc.bottomSheetController.present(viewController: alert)
    }
    
    func applyButtonDidPress(from dateFrom: Date?, to dateTo: Date?) {
        let index = rows.index { $0 == .dateRange }
        guard let idx = index else { return }
        
        if let selectedDate = getSelectedDate() {
            viewModels[idx].detail = selectedDate
        }
        
        filterViewModelProtocol?.didFilterReloadCell(idx)
    }
}
