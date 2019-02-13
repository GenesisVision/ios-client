//
//  SortingDelegateManager.swift
//  genesisvision-ios
//
//  Created by George on 08/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableView

protocol SortingDelegate: class {
    func didSelectSorting()
}

enum SortingType {
    case programs, funds, dashboardPrograms, dashboardFunds, trades
}

class SortingManager: NSObject {

    var sortingType: SortingType = .programs
    
    var highToLowValue: Bool = true
    var selectedIndex: Int = 0
    
    var sortingValues: [String]!
    
    init(_ sortingType: SortingType) {
        super.init()
        
        self.sortingType = sortingType
        
        setup()
    }
    
    // MARK: - Private methods
    private func getProgramsSelectedSorting() -> ProgramsAPI.Sorting_v10ProgramsGet {
        let selectedValue = getSelectedSortingValue()
        
        switch selectedValue {
        case "profit":
            return highToLowValue ? .byProfitDesc : .byProfitAsc
        case "level":
            return highToLowValue ? .byLevelDesc : .byLevelAsc
        case "balance":
            return highToLowValue ? .byBalanceDesc : .byBalanceAsc
        case "drawdown":
            return highToLowValue ? .byDrawdownDesc : .byDrawdownAsc
        case "end of period":
            return highToLowValue ? .byEndOfPeriodDesc : .byEndOfPeriodAsc
        case "trades":
            return highToLowValue ? .byTradesDesc : .byTradesAsc
        case "investors":
            return highToLowValue ? .byInvestorsDesc : .byInvestorsAsc
        case "title":
            return highToLowValue ? .byTitleDesc : .byTitleAsc
        case "new":
            return highToLowValue ? .byNewDesc : .byNewAsc
        case "investor":
            return highToLowValue ? .byInvestorsDesc : .byInvestorsAsc
        case "currency":
            return highToLowValue ? .byCurrDesc : .byCurrAsc
        default:
            return highToLowValue ? .byProfitDesc : .byProfitAsc
        }
    }
    
    private func getFundsSelectedSorting() -> FundsAPI.Sorting_v10FundsGet {
        let selectedValue = getSelectedSortingValue()
        
        switch selectedValue {
        case "profit":
            return highToLowValue ? .byProfitDesc : .byProfitAsc
        case "balance":
            return highToLowValue ? .byBalanceDesc : .byBalanceAsc
        case "investors":
            return highToLowValue ? .byInvestorsDesc : .byInvestorsAsc
        case "drawdown":
            return highToLowValue ? .byDrawdownDesc : .byDrawdownAsc
        case "title":
            return highToLowValue ? .byTitleDesc : .byTitleAsc
        case "new":
            return highToLowValue ? .byNewDesc : .byNewAsc
        default:
            return highToLowValue ? .byProfitDesc : .byProfitAsc
        }
    }
    
    private func getDashboardProgramsSelectedSorting() -> InvestorAPI.Sorting_v10InvestorProgramsGet {
        let selectedValue = getSelectedSortingValue()
        
        switch selectedValue {
        case "profit":
            return highToLowValue ? .byProfitDesc : .byProfitAsc
        case "level":
            return highToLowValue ? .byLevelDesc : .byLevelAsc
        case "balance":
            return highToLowValue ? .byBalanceDesc : .byBalanceAsc
        case "drawdown":
            return highToLowValue ? .byDrawdownDesc : .byDrawdownAsc
        case "end of period":
            return highToLowValue ? .byEndOfPeriodDesc : .byEndOfPeriodAsc
        case "trades":
            return highToLowValue ? .byTradesDesc : .byTradesAsc
        case "investors":
            return highToLowValue ? .byInvestorsDesc : .byInvestorsAsc
        case "title":
            return highToLowValue ? .byTitleDesc : .byTitleAsc
        case "new":
            return highToLowValue ? .byNewDesc : .byNewAsc
        case "investor":
            return highToLowValue ? .byInvestorsDesc : .byInvestorsAsc
        case "currency":
            return highToLowValue ? .byCurrDesc : .byCurrAsc
        default:
            return highToLowValue ? .byProfitDesc : .byProfitAsc
        }
    }
    
    private func getDashboardFundsSelectedSorting() -> InvestorAPI.Sorting_v10InvestorFundsGet {
        let selectedValue = getSelectedSortingValue()
        
        switch selectedValue {
        case "profit":
            return highToLowValue ? .byProfitDesc : .byProfitAsc
        case "balance":
            return highToLowValue ? .byBalanceDesc : .byBalanceAsc
        case "investors":
            return highToLowValue ? .byInvestorsDesc : .byInvestorsAsc
        case "drawdown":
            return highToLowValue ? .byDrawdownDesc : .byDrawdownAsc
        case "title":
            return highToLowValue ? .byTitleDesc : .byTitleAsc
        case "new":
            return highToLowValue ? .byNewDesc : .byNewAsc
        default:
            return highToLowValue ? .byProfitDesc : .byProfitAsc
        }
    }
    
    
    private func getTradesSelectedSorting() -> ProgramsAPI.Sorting_v10ProgramsByIdTradesGet {
        let selectedValue = getSelectedSortingValue()
        
        switch selectedValue {
        case "date":
            return highToLowValue ? .byDateDesc : .byDateAsc
        case "ticket":
            return highToLowValue ? .byTicketDesc : .byTicketAsc
        case "symbol":
            return highToLowValue ? .bySymbolDesc : .bySymbolAsc
        case "direction":
            return highToLowValue ? .byDirectionDesc : .byDirectionAsc
        default:
            return highToLowValue ? .byDateDesc : .byDateAsc
        }
    }
    
    private func setup() {
        switch sortingType {
        case .programs, .dashboardPrograms:
            sortingValues = ["profit", "level", "drawdown", "trades", "balance", "end of period", "title", "investors", "currency", "new"]
        case .funds, .dashboardFunds:
            sortingValues = ["profit", "balance", "investors", "drawdown", "title", "new"]
        case .trades:
            sortingValues = ["date", "ticket", "symbol", "direction"]
        }
    }
    
    // MARK: - Public methods
    func getSelectedSortingValue() -> String {
        return sortingValues[selectedIndex]
    }
    
    func reset() {
        selectedIndex = 0
    }
    
    func changeSorting(at index: Int) {
        selectedIndex = index
    }
    
    func sortTitle() -> String? {
        return "Sort by " + getSelectedSortingValue()
    }
    
    func getSelectedSorting() -> Any {
        switch sortingType {
        case .programs:
            return getProgramsSelectedSorting()
        case .funds:
            return getFundsSelectedSorting()
        case .dashboardPrograms:
            return getDashboardProgramsSelectedSorting()
        case .dashboardFunds:
            return getDashboardFundsSelectedSorting()
        case .trades:
            return getTradesSelectedSorting()
        }
    }
}

final class SortingDelegateManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: SortingDelegate?
    
    var sortingManager: SortingManager?
    
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [DashboardCurrencyTableViewCellViewModel.self]
    }
    
    // MARK: - Init
    init(_ sortingManager: SortingManager) {
        super.init()
        
        self.sortingManager = sortingManager
    }
    
    func reset() {
        sortingManager?.reset()
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        sortingManager?.changeSorting(at: indexPath.row)
        
        delegate?.didSelectSorting()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortingManager?.sortingValues.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardCurrencyTableViewCell", for: indexPath) as? DashboardCurrencyTableViewCell else {
            let cell = UITableViewCell()
            return cell
        }
        
        let title = sortingManager?.sortingValues[indexPath.row]
        let isSelected = indexPath.row == sortingManager?.selectedIndex
        cell.configure(title: title, selected: isSelected)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor = UIColor.Cell.subtitle.withAlphaComponent(0.3)
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor = UIColor.Cell.bg
        }
    }
}


