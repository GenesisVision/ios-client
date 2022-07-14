//
//  SortingDelegateManager.swift
//  genesisvision-ios
//
//  Created by George on 08/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableView

protocol SortingDelegate: AnyObject {
    func didSelectSorting()
}

enum SortingType {
    case programs, funds, follows, tradesOpen, trades, signalTradesOpen, assets
}

enum SortingValue: String {
    case profit = "Profit"
    case level = "Level"
    case endPeriod = "End of period"
    case equity = "Equity"
    case title = "Title"
    case new = "New"
    case drawdown = "Drawdown"
    case trades = "Trades"
    case subscribers = "Subscribers"
    case size = "Size"
    case investors = "Investors"
    case date = "Date"
    case ticket = "Ticket"
//    case symbol = "Symbol"
    case symbol = "Asset"
    case direction = "Direction"
    case volume = "Volume"
    case price = "Price"
    case levelProgress = "Level progress"
    case value = "Value"
//    case asset = "Asset"
    case asset = "Name"
    case change = "Change"
    case marketCap = "Market Cap"
}

class SortingManager: NSObject {

    var sortingType: SortingType = .programs
    
    var highToLowValue: Bool = true
    var selectedIndex: Int = 0
    
    var sortingValues: [SortingValue]!
    
    init(_ sortingType: SortingType) {
        super.init()
        
        self.sortingType = sortingType
        
        setup()
    }
    
    // MARK: - Private methods
    private func getProgramsSelectedSorting() -> ProgramsFilterSorting {
        let selectedValue = getSelectedSortingValue()
        
        switch selectedValue {
        case .profit:
            return highToLowValue ? .byProfitDesc : .byProfitAsc
        case .equity:
            return highToLowValue ? .byEquityDesc : .byEquityAsc
        case .level:
            return highToLowValue ? .byLevelDesc : .byLevelAsc
        case .title:
            return highToLowValue ? .byTitleDesc : .byTitleAsc
        case .new:
            return highToLowValue ? .byNewDesc : .byNewAsc
        case .endPeriod:
            return highToLowValue ? .byPeriodDesc : .byPeriodAsc
        case .investors:
            return highToLowValue ? .byInvestorsDesc : .byInvestorsAsc
        case .drawdown:
            return highToLowValue ? .byDrawdownDesc : .byDrawdownAsc
        case .levelProgress:
            return highToLowValue ? .byLevelProgressDesc : .byLevelProgressAsc
        case .value:
            return highToLowValue ? .byValueDesc : .byValueAsc
        default:
            return highToLowValue ? .byProfitDesc : .byProfitAsc
        }
    }
    private func getFollowsSelectedSorting() -> FollowFilterSorting {
        let selectedValue = getSelectedSortingValue()
        
        switch selectedValue {
        case .profit:
            return highToLowValue ? .byProfitDesc : .byProfitAsc
        case .drawdown:
            return highToLowValue ? .byDrawdownDesc : .byDrawdownAsc
        case .trades:
            return highToLowValue ? .byTradesDesc : .byTradesAsc
        case .title:
            return highToLowValue ? .byTitleDesc : .byTitleAsc
        case .new:
            return highToLowValue ? .byNewDesc : .byNewAsc
        case .subscribers:
            return highToLowValue ? .bySubscribersDesc : .bySubscribersAsc
        case .equity:
            return highToLowValue ? .byEquityDesc : .byEquityAsc
        default:
            return highToLowValue ? .byProfitDesc : .byProfitAsc
        }
    }
    private func getFundsSelectedSorting() -> FundsFilterSorting {
        let selectedValue = getSelectedSortingValue()
        
        switch selectedValue {
        case .profit:
            return highToLowValue ? .byProfitDesc : .byProfitAsc
        case .investors:
            return highToLowValue ? .byInvestorsDesc : .byInvestorsAsc
        case .drawdown:
            return highToLowValue ? .byDrawdownDesc : .byDrawdownAsc
        case .title:
            return highToLowValue ? .byTitleDesc : .byTitleAsc
        case .new:
            return highToLowValue ? .byNewDesc : .byNewAsc
        case .size:
            return highToLowValue ? .bySizeDesc : .bySizeAsc
        case .value:
            return highToLowValue ? .byValueDesc : .byValueAsc
        default:
            return highToLowValue ? .byProfitDesc : .byProfitAsc
        }
    }
    private func getTradesOpenSelectedSorting() -> TradeSorting {
        let selectedValue = getSelectedSortingValue()
        
        switch selectedValue {
        case .profit:
            return highToLowValue ? .byProfitDesc : .byProfitAsc
        case .date:
            return highToLowValue ? .byDateDesc : .byDateAsc
        case .ticket:
            return highToLowValue ? .byTicketDesc : .byTicketAsc
        case .symbol:
            return highToLowValue ? .bySymbolDesc : .bySymbolAsc
        case .direction:
            return highToLowValue ? .byDirectionDesc : .byDirectionAsc
        case .volume:
            return highToLowValue ? .byVolumeDesc : .byVolumeAsc
        case .price:
            return highToLowValue ? .byPriceDesc : .byPriceAsc
        default:
            return highToLowValue ? .byProfitDesc : .byProfitAsc
        }
    }
    private func getTradesSelectedSorting() -> TradeSorting {
        let selectedValue = getSelectedSortingValue()
        
        
        switch selectedValue {
        case .profit:
            return highToLowValue ? .byProfitDesc : .byProfitAsc
        case .date:
            return highToLowValue ? .byDateDesc : .byDateAsc
        case .ticket:
            return highToLowValue ? .byTicketDesc : .byTicketAsc
        case .symbol:
            return highToLowValue ? .bySymbolDesc : .bySymbolAsc
        case .direction:
            return highToLowValue ? .byDirectionDesc : .byDirectionAsc
        case .volume:
            return highToLowValue ? .byVolumeDesc : .byVolumeAsc
        case .price:
            return highToLowValue ? .byPriceDesc : .byPriceAsc
        default:
            return highToLowValue ? .byProfitDesc : .byProfitAsc
        }
    }
    private func getAssetsSelectedSorting() -> CoinsFilterSorting {
        let selectedValue = getSelectedSortingValue()
        
        switch selectedValue {
        case .volume:
            return highToLowValue ? .byVolumeDesc : .byVolumeAsc
        case .price:
            return highToLowValue ? .byPriceDesc : .byPriceAsc
        case .asset:
            return highToLowValue ? .byAssetDesc : .byAssetAsc
        case .symbol:
            return highToLowValue ? .bySymbolDesc : .bySymbolAsc
        case .change:
            return highToLowValue ? .byChangeDesc : .byChangeAsc
        case .marketCap:
            return highToLowValue ? .byMarketCapDesc : .byMarketCapAsc
        default:
            return highToLowValue ? .byMarketCapDesc : .byMarketCapAsc
        }
        
    }
    
    private func setup() {
        switch sortingType {
        case .programs:
            sortingValues = [.profit, .level, .endPeriod, .equity, .title]
        case .follows:
            sortingValues = [.profit, .equity, .title, .subscribers, .drawdown]
        case .funds:
            sortingValues = [.profit, .size, .title, .investors, .drawdown]
        case .assets:
            sortingValues = [.marketCap, .asset, .symbol, .price, .change, .volume]
        case .tradesOpen, .trades, .signalTradesOpen:
            sortingValues = [.date, .ticket, .symbol, .direction, .volume, .price, .profit]
        }
    }
    
    // MARK: - Public methods
    func getSelectedSortingValue() -> SortingValue {
        return sortingValues[selectedIndex]
    }
    
    func reset() {
        selectedIndex = 0
    }
    
    func changeSorting(at index: Int) {
        selectedIndex = index
    }
    
    func sortTitle() -> String? {
        return "Sort by " + getSelectedSortingValue().rawValue
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
        case .assets:
            return getAssetsSelectedSorting()
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
        
        let title = manager?.sortingValues[indexPath.row].rawValue
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


