//
//  SortingDelegateManager.swift
//  genesisvision-ios
//
//  Created by George on 08/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableView

protocol SortingDelegate: class {
    func didSelectSorting(at indexPath: IndexPath)
}

final class SortingDelegateManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    weak var tableViewProtocol: SortingDelegate?
    
    // MARK: - Variables
    var highToLowValue: Bool = true
    
    var sorting: InvestorAPI.Sorting_v10InvestorProgramsGet = Constants.Sorting.dashboardDefault
    
    var sortingDescKeys: [InvestorAPI.Sorting_v10InvestorProgramsGet] = [.byProfitDesc,
                                                                         .byLevelDesc,
                                                                         .byBalanceDesc,
                                                                         .byTradesDesc,
                                                                         .byEndOfPeriodDesc,
                                                                         .byTitleDesc]
    
    var sortingAscKeys: [InvestorAPI.Sorting_v10InvestorProgramsGet] = [.byProfitAsc,
                                                                        .byLevelAsc,
                                                                        .byBalanceAsc,
                                                                        .byTradesAsc,
                                                                        .byEndOfPeriodAsc,
                                                                        .byTitleAsc]
    
    var sortingValues: [String] = ["profit",
                                   "level",
                                   "balance",
                                   "orders",
                                   "end of period",
                                   "title"]
    
    struct SortingList {
        var sortingValue: String
        var sortingKey: InvestorAPI.Sorting_v10InvestorProgramsGet
    }
    
    var sortingDescList: [SortingList] {
        return sortingValues.enumerated().map { (index, element) in
            return SortingList(sortingValue: element, sortingKey: sortingDescKeys[index])
        }
    }
    
    var sortingAscList: [SortingList] {
        return sortingValues.enumerated().map { (index, element) in
            return SortingList(sortingValue: element, sortingKey: sortingAscKeys[index])
        }
    }
    
    // MARK: - Init
    override init() {
        super.init()
    }
    
    // MARK: - Private methods
    func getSortingValue(sortingKey: InvestorAPI.Sorting_v10InvestorProgramsGet) -> String {
        guard let index = sortingDescKeys.index(of: sortingKey) else { return "" }
        return sortingValues[index]
    }
    
    func changeSorting(at index: Int) {
        sorting = highToLowValue ? sortingDescKeys[index] : sortingAscKeys[index]
    }
    
    func getSelectedSortingIndex() -> Int {
        return sortingDescKeys.index(of: sorting) ?? 0
    }
    
    func sortTitle() -> String? {
        return "Sort by " + getSortingValue(sortingKey: sorting)
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        changeSorting(at: indexPath.row)
        
        tableViewProtocol?.didSelectSorting(at: indexPath)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortingValues.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = sortingValues[indexPath.row]
        cell.backgroundColor = UIColor.Cell.bg
        
        cell.textLabel?.textColor = indexPath.row == getSelectedSortingIndex() ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) :  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.7)
        cell.accessoryType = indexPath.row == getSelectedSortingIndex() ? .checkmark : .none
        cell.accessoryView = UIImageView(image: #imageLiteral(resourceName: "img_radio_selected_icon"))
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell  = tableView.cellForRow(at: indexPath), cell.accessoryType == .none {
            cell.textLabel?.textColor = UIColor.Cell.title
            cell.contentView.backgroundColor = UIColor.Cell.title.withAlphaComponent(0.3)
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell  = tableView.cellForRow(at: indexPath), cell.accessoryType == .none {
            cell.textLabel?.textColor = UIColor.Cell.subtitle
            cell.contentView.backgroundColor = UIColor.Cell.bg
        }
    }
}


