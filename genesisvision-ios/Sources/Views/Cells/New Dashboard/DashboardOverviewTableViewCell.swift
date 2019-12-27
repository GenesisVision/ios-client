//
//  DashboardOverviewTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 20.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

struct ProfitChange {
    var value: Double
    var percent: Double
    
    init(value: Double? = nil, percent: Double? = nil) {
        self.value = value ?? 0.0
        self.percent = percent ?? 0.0
    }
    
    init(_ model: DashboardTimeframeProfit? = nil) {
        self.value = model?.profit ?? 0.0
        self.percent = model?.profitPercent ?? 0.0
    }
}

struct Profits {
    var day: ProfitChange
    var week: ProfitChange
    var month: ProfitChange
    
    init(_ model: DashboardProfits? = nil) {
        day = ProfitChange(model?.day)
        week = ProfitChange(model?.week)
        month = ProfitChange(model?.month)
    }
    
    init(day: ProfitChange, week: ProfitChange, month: ProfitChange) {
        self.day = ProfitChange(value: day.value, percent: day.percent)
        self.week = ProfitChange(value: week.value, percent: week.percent)
        self.month = ProfitChange(value: month.value, percent: month.percent)
    }
}

struct DashboardOverviewData: BaseData {
    var title: String
    var type: CellActionType
    
    var total: Double
    var invested: Double
    var trading: Double
    var wallets: Double
    
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
    
    var currency: CurrencyType
    
    init(_ model: DashboardSummary?, currency: CurrencyType) {
        title = "Balance"
        type = .none
        
        self.total = model?.total ?? 0.0
        self.invested = model?.invested ?? 0.0
        self.trading = model?.trading ?? 0.0
        self.wallets = model?.wallets ?? 0.0
        
        self.profits = Profits(model?.profits)
        self.currency = currency
    }
    
    init() {
        title = "Balance"
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
    let data: DashboardOverviewData?
    weak var delegate: BaseTableViewProtocol?
}
extension DashboardOverviewTableViewCellViewModel: CellViewModel {
    func setup(on cell: DashboardOverviewTableViewCell) {
        cell.configure(data, delegate: delegate)
    }
}

class DashboardOverviewTableViewCell: BaseTableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var labelsView: DashboardOverviewLabelsView!
   
    func configure(_ data: DashboardOverviewData?, delegate: BaseTableViewProtocol?) {
        guard let data = data else { return }
        loaderView.stopAnimating()
        loaderView.isHidden = true
        
        self.type = .none
        self.delegate = delegate
    
        labelsView.configure(data)
        labelsView.progressView.dataSource = self
        
        labelsView.changeLabelsView.dayLabel.valueLabel.isHidden = true
        labelsView.changeLabelsView.weekLabel.valueLabel.isHidden = true
        labelsView.changeLabelsView.monthLabel.valueLabel.isHidden = true
        
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
