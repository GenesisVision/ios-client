//
//  FilterViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 31.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import UIKit

protocol FilterViewModelProtocol: AnyObject {
    func didFilterReloadCell(_ row: Int)
}

enum FilterType {
    case programs, funds, follows
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
        case tags
        case assets
        case dateRange
        case onlyActive
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
    var tagsDelegateManager: TagsDelegateManager?
    var levelsFilterView: LevelsFilterView?
    var dateRangeView: DateRangeView?
    var onlyActive: Bool?
    
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
            rows = [.currency, .dateRange, .sort]
        case .follows:
            rows = [.dateRange, .sort]
        case .funds:
            rows = [.dateRange, .sort]
        }
        
        self.router = router
        self.filterViewModelProtocol = filterViewModelProtocol
        self.listViewModel = listViewModel
        
        setupManagers(filterModel, sortingType: sortingType)
        
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
    
    func changeHighToLowValue() {
        if let sortingManager = sortingDelegateManager?.manager {
            sortingManager.highToLowValue = !sortingManager.highToLowValue
        }
        
        didSelectSorting()
    }
    
    func reset() {
        currencyDelegateManager?.reset()
        sortingDelegateManager?.reset()
        tagsDelegateManager?.reset()
        levelsFilterView?.reset()
        dateRangeView?.reset()
        onlyActive = false
        
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
                if let detail = sortingDelegateManager?.manager?.getSelectedSortingValue() {
                    viewModels[idx].detail = detail.rawValue
                }
            case .tags, .assets:
                if let detail = tagsDelegateManager?.manager?.getSelectedValues() {
                    viewModels[idx].detail = detail
                }
            case .onlyActive:
                viewModels[idx].switchOn = onlyActive
            }
        }
    }
    
    func apply(completion: @escaping CompletionBlock) {
        guard let filterModel = listViewModel?.filterModel else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        if let minLevel = levelsFilterView?.minLevel, let maxLevel = levelsFilterView?.maxLevel {
            filterModel.levelModel.minLevel = minLevel
            filterModel.levelModel.maxLevel = maxLevel
        }
        
        if let sortingManager = sortingDelegateManager?.manager {
            filterModel.sortingModel.selectedIndex = sortingManager.selectedIndex
            filterModel.sortingModel.highToLowValue = sortingManager.highToLowValue
            filterModel.sortingModel.selectedSorting = sortingManager.getSelectedSorting()
        }
        
        if let tagsManager = tagsDelegateManager?.manager {
            filterModel.tagsModel.selectedIdxs = tagsManager.selectedIdxs
            filterModel.tagsModel.selectedTags = tagsManager.getSelectedTagValues()
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
        
        if let onlyActive = onlyActive {
            filterModel.onlyActive = onlyActive
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
            case .onlyActive:
                onlyActive = filterModel.onlyActive
            case .tags, .assets:
                setupTagsManager(filterModel)
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
        sortingDelegateManager?.manager?.selectedIndex = filterModel.sortingModel.selectedIndex
        sortingDelegateManager?.manager?.highToLowValue = filterModel.sortingModel.highToLowValue
    }
    
    private func setupTagsManager(_ filterModel: FilterModel) {
        tagsDelegateManager = TagsDelegateManager(filterType)
        tagsDelegateManager?.delegate = self
        tagsDelegateManager?.manager?.selectedIdxs = filterModel.tagsModel.selectedIdxs
    }
    
    private func setup() {
        var tableViewCellViewModel: FilterTableViewCellViewModel?
        
        for row in rows {
            switch row {
            case .levels:
                tableViewCellViewModel = FilterTableViewCellViewModel(title: "Levels", detail: nil, detailImage: nil, switchOn: nil, style: .detail, delegate: nil)
                tableViewCellViewModel?.detail = levelsFilterView?.getSelectedLevels()
                
                viewModels.append(tableViewCellViewModel!)
            case .currency:
                tableViewCellViewModel = FilterTableViewCellViewModel(title: "Currency", detail: nil, detailImage: nil, switchOn: nil, style: .detail, delegate: nil)
                
                if let selectedValue = listViewModel?.filterModel.currencyModel.selectedCurrency {
                    tableViewCellViewModel?.detail = selectedValue
                } else {
                    tableViewCellViewModel?.detail = currencyDelegateManager?.getSelectedCurrencyValue()
                }
                
                viewModels.append(tableViewCellViewModel!)
            case .dateRange:
                tableViewCellViewModel = FilterTableViewCellViewModel(title: "Date Range", detail: nil, detailImage: nil, switchOn: nil, style: .detail, delegate: nil)
                
                if let selectedValue = getSelectedDate() {
                    tableViewCellViewModel?.detail = selectedValue
                }
                
                viewModels.append(tableViewCellViewModel!)
            case .sort:
                guard let highToLowValue = sortingDelegateManager?.manager?.highToLowValue else { return }
                
                tableViewCellViewModel = FilterTableViewCellViewModel(title: "Sort", detail: nil, detailImage: highToLowValue ? #imageLiteral(resourceName: "img_profit_filter_icon") : #imageLiteral(resourceName: "img_profit_filter_desc_icon"), switchOn: nil, style: .detail, delegate: nil)
                if let selectedValue = sortingDelegateManager?.manager?.getSelectedSortingValue() {
                    tableViewCellViewModel?.detail = selectedValue.rawValue
                }
                viewModels.append(tableViewCellViewModel!)
            case .tags, .assets:
                var title = ""
                if filterType == .programs {
                    title = "Tags"
                } else if filterType == .funds {
                    title = "Assets"
                }
                
                tableViewCellViewModel = FilterTableViewCellViewModel(title: title, detail: nil, detailImage: nil, switchOn: nil, style: .detail, delegate: nil)
                if let selectedValue = tagsDelegateManager?.manager?.getSelectedValues() {
                    tableViewCellViewModel?.detail = selectedValue
                }
                viewModels.append(tableViewCellViewModel!)
            case .onlyActive:
                tableViewCellViewModel = FilterTableViewCellViewModel(title: "Only active", detail: nil, detailImage: nil, switchOn: onlyActive, style: .switcher, delegate: self)
                
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
        let index = rows.firstIndex { $0 == .levels }
        guard let idx = index else { return }
        
        viewModels[idx].detail = levelsFilterView?.getSelectedLevels()
        
        filterViewModelProtocol?.didFilterReloadCell(idx)
    }
    
    func showPickerMinPicker(min minLevel: Int, max maxLevel: Int) {
        guard let vc = router.currentController as? BaseViewController else { return }
        
        let alert = UIAlertController(style: .actionSheet, title: nil, message: nil)
    
        var values: [String] = []
        for idx in Filters.minLevel...Filters.maxLevel - 1 {
            values.append("\(idx)")
        }
        
        var minValue = 1
        if let text = self.levelsFilterView?.minTextField.text, let min = Int(text) {
            minValue = min
        }
        let selectedIndex = values.firstIndex{ $0 == "\(minValue)" } ?? 0
        
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
        let selectedIndex = values.firstIndex{ $0 == "\(maxValue)" } ?? 0
        
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
        let index = rows.firstIndex { $0 == .currency }
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
        let index = rows.firstIndex { $0 == .sort }
        guard let idx = index else { return }
        
        if let manager = sortingDelegateManager?.manager {
            let detail = manager.getSelectedSortingValue()
            let highToLowValue = manager.highToLowValue
            
            viewModels[idx].detail = detail.rawValue
            viewModels[idx].detailImage = highToLowValue ? #imageLiteral(resourceName: "img_profit_filter_icon") : #imageLiteral(resourceName: "img_profit_filter_desc_icon")
        }
        
        filterViewModelProtocol?.didFilterReloadCell(idx)
    }
}

extension FilterViewModel: TagsDelegate {
    func didSelectTag() {
        let index = rows.firstIndex { $0 == .tags || $0 == .assets }
        guard let idx = index else { return }
        
        if let manager = tagsDelegateManager?.manager {
            let detail = manager.getSelectedValues()
            
            viewModels[idx].detail = detail
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
    
    func showDatePicker(from dateFrom: Date, to dateTo: Date, isFrom: Bool = true) {
        guard let vc = router.currentController as? BaseViewController else { return }
        
        let alert = UIAlertController(style: .actionSheet, title: nil, message: nil)

        if isFrom {
            alert.addDatePicker(mode: .date, date: dateFrom, minimumDate: nil, maximumDate: Date()) { [weak self] date in
                DispatchQueue.main.async {
                    self?.dateRangeView?.dateFrom = date
                    self?.dateRangeView?.dateTo = dateTo.compare(date) == .orderedAscending ? date : dateTo
                }
            }
        } else {
            alert.addDatePicker(mode: .date, date: dateTo, minimumDate: nil, maximumDate: Date()) { [weak self] date in
                DispatchQueue.main.async {
                    self?.dateRangeView?.dateFrom = dateFrom.compare(date) == .orderedDescending ? date : dateFrom
                    self?.dateRangeView?.dateTo = date
                }
            }
        }

        alert.addAction(title: "Done", style: .cancel) { (action) in
            print(action)
        }
        vc.bottomSheetController.present(viewController: alert)
    }
    
    func applyButtonDidPress(from dateFrom: Date?, to dateTo: Date?) {
        let index = rows.firstIndex { $0 == .dateRange }
        guard let idx = index else { return }
        
        if let selectedDate = getSelectedDate() {
            viewModels[idx].detail = selectedDate
        }
        
        filterViewModelProtocol?.didFilterReloadCell(idx)
    }
}

extension FilterViewModel: FilterTableViewCellProtocol {
    func didChangeSwitch(value: Bool) {
        onlyActive = value
    }
}
