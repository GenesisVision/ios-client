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
    case programs, funds, follows, tradesOpen, trades, signalTradesOpen
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
    private func getProgramsSelectedSorting() -> ProgramsFilterSorting {
        let selectedValue = getSelectedSortingValue()
        
        switch selectedValue {
        case "profit":
            return highToLowValue ? .byProfitDesc : .byProfitAsc
        case "equity":
            return highToLowValue ? .byEquityDesc : .byEquityAsc
        case "level":
            return highToLowValue ? .byLevelDesc : .byLevelAsc
        case "drawdown":
            return highToLowValue ? .byDrawdownDesc : .byDrawdownAsc
        case "investors":
            return highToLowValue ? .byInvestorsDesc : .byInvestorsAsc
        case "title":
            return highToLowValue ? .byTitleDesc : .byTitleAsc
        case "new":
            return highToLowValue ? .byNewDesc : .byNewAsc
        default:
            return highToLowValue ? .byProfitDesc : .byProfitAsc
        }
    }
    private func getFollowsSelectedSorting() -> FollowFilterSorting {
        let selectedValue = getSelectedSortingValue()
        
        switch selectedValue {
        case "profit":
            return highToLowValue ? .byProfitDesc : .byProfitAsc
        case "level":
            return highToLowValue ? .bySubscribersDesc : .bySubscribersAsc
        case "drawdown":
            return highToLowValue ? .byDrawdownDesc : .byDrawdownAsc
        case "trades":
            return highToLowValue ? .byTradesDesc : .byTradesAsc
        case "title":
            return highToLowValue ? .byTitleDesc : .byTitleAsc
        case "new":
            return highToLowValue ? .byNewDesc : .byNewAsc
        default:
            return highToLowValue ? .byProfitDesc : .byProfitAsc
        }
    }
    private func getFundsSelectedSorting() -> FundsFilterSorting {
        let selectedValue = getSelectedSortingValue()
        
        switch selectedValue {
        case "profit":
            return highToLowValue ? .byProfitDesc : .byProfitAsc
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
    private func getTradesOpenSelectedSorting() -> TradeSorting {
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
        case "volume":
            return highToLowValue ? .byVolumeDesc : .byVolumeAsc
        case "price":
            return highToLowValue ? .byPriceDesc : .byPriceAsc
        case "profit":
            return highToLowValue ? .byProfitDesc : .byProfitAsc
        default:
            return highToLowValue ? .byDateDesc : .byDateAsc
        }
    }
    private func getTradesSelectedSorting() -> TradeSorting {
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
        case "volume":
            return highToLowValue ? .byVolumeDesc : .byVolumeAsc
        case "price":
            return highToLowValue ? .byPriceDesc : .byPriceAsc
        case "profit":
            return highToLowValue ? .byProfitDesc : .byProfitAsc

        default:
            return highToLowValue ? .byDateDesc : .byDateAsc
        }
    }
//    private func getSignalTradesOpenSelectedSorting() -> SignalAPI.Sorting_getOpenSignalTrades {
//        let selectedValue = getSelectedSortingValue()
//
//        switch selectedValue {
//        case "date":
//            return highToLowValue ? .byDateDesc : .byDateAsc
//        case "ticket":
//            return highToLowValue ? .byTicketDesc : .byTicketAsc
//        case "symbol":
//            return highToLowValue ? .bySymbolDesc : .bySymbolAsc
//        case "direction":
//            return highToLowValue ? .byDirectionDesc : .byDirectionAsc
//        case "volume":
//            return highToLowValue ? .byVolumeDesc : .byVolumeAsc
//        case "price":
//            return highToLowValue ? .byPriceDesc : .byPriceAsc
//        case "profit":
//            return highToLowValue ? .byProfitDesc : .byProfitAsc
//        default:
//            return highToLowValue ? .byDateDesc : .byDateAsc
//        }
//    }
    
    private func setup() {
        switch sortingType {
        case .programs:
            sortingValues = ["profit", "equity", "level", "drawdown", "title", "investors", "new"]
        case .follows:
            sortingValues = ["profit", "level", "drawdown", "trades", "title", "new"]
        case .funds:
            sortingValues = ["profit", "investors", "drawdown", "title", "new"]
        case .tradesOpen, .trades, .signalTradesOpen:
            sortingValues = ["date", "ticket", "symbol", "direction", "volume", "price", "profit"]
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
        case .follows:
            return getFollowsSelectedSorting()
        case .funds:
            return getFundsSelectedSorting()
        case .tradesOpen:
            return getTradesOpenSelectedSorting()
        case .trades:
            return getTradesSelectedSorting()
        case .signalTradesOpen:
            return getTradesSelectedSorting()
        }
    }
}

final class SortingDelegateManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: SortingDelegate?
    
    var manager: SortingManager?
    
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [DashboardCurrencyTableViewCellViewModel.self]
    }
    
    // MARK: - Init
    init(_ sortingManager: SortingManager) {
        super.init()
        
        self.manager = sortingManager
    }
    
    func reset() {
        manager?.reset()
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        manager?.changeSorting(at: indexPath.row)
        
        delegate?.didSelectSorting()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager?.sortingValues.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardCurrencyTableViewCell", for: indexPath) as? DashboardCurrencyTableViewCell else {
            let cell = UITableViewCell()
            return cell
        }
        
        let title = manager?.sortingValues[indexPath.row]
        let isSelected = indexPath.row == manager?.selectedIndex
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


