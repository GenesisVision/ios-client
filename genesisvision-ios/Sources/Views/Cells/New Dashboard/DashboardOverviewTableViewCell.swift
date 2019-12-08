//
//  DashboardOverviewTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 20.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

struct ProfitChange {
    let value: Double
    let percent: Double
}
struct Profits {
    let day: ProfitChange
    let week: ProfitChange
    let month: ProfitChange
}
struct DashboardOverviewData: BaseData {
    var title: String
    var showActionsView: Bool
    var type: CellActionType
    
    let total: Double
    let invested: Double
    let trading: Double
    let wallets: Double
    
    var investedProgress: Double {
        return invested/total
    }
    
    var tradingProgress: Double {
        return trading/total
    }
    
    var walletsProgress: Double {
        return wallets/total
    }
    
    var profits: Profits
    
    let currency: CurrencyType
    
    init(_ model: BaseData) {
//        TODO: parse
//        self.total = model.total
//        self.invested = model.invested
//        self.trading = model.trading
//        self.wallets = model.wallets
//
//        self.profits.0 = model.profits.day.profitPercent
//        self.profits.1 = model.profits.week.profitPercent
//        self.profits.2 = model.profits.month.profitPercent
        
        self.init()
    }
    
    init() {
        title = "Balance"
        showActionsView = false
        type = .none
        
        total = 100.0
        invested = 50.0
        trading = 30.0
        wallets = 20.0
        profits = Profits(day: ProfitChange(value: 2000, percent: 20),
                          week: ProfitChange(value: 3000, percent: 30),
                          month: ProfitChange(value: 5000, percent: 50))
        currency = .usd
    }
}

struct DashboardOverviewTableViewCellViewModel {
    let data: DashboardOverviewData
    weak var delegate: BaseCellProtocol?
}
extension DashboardOverviewTableViewCellViewModel: CellViewModel {
    func setup(on cell: DashboardOverviewTableViewCell) {
        cell.configure(data, delegate: delegate)
    }
}

class DashboardOverviewTableViewCell: BaseTableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var labelsView: DashboardOverviewLabelsView!
    
    func configure(_ data: DashboardOverviewData, delegate: BaseCellProtocol?) {
        self.type = .none
        self.delegate = delegate
    
        labelsView.configure(data)
        labelsView.progressView.dataSource = self
        
        labelsView.progressView.setProgress(section: 0, to: Float(data.investedProgress))
        labelsView.progressView.setProgress(section: 1, to: Float(data.tradingProgress))
        labelsView.progressView.setProgress(section: 2, to: Float(data.walletsProgress))
    }
}

extension DashboardOverviewTableViewCell: MultiProgressViewDataSource {
    func numberOfSections(in progressView: MultiProgressView) -> Int {
        return 3
    }
    
    func progressView(_ progressView: MultiProgressView, viewForSection section: Int) -> ProgressViewSection {
        let sectionView = ProgressViewSection()
        
        switch section {
        case 0:
            sectionView.backgroundColor = UIColor.Common.primary
        case 1:
            sectionView.backgroundColor = UIColor.Common.yellow
        case 2:
            sectionView.backgroundColor = UIColor.Common.purple
        default:
            break
        }
        
        return sectionView
    }
}
