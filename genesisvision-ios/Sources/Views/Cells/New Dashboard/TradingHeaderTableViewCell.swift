//
//  TradingHeaderTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 24.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

struct TradingHeaderData: BaseData {
    var title: String
    var showActionsView: Bool
    var type: CellActionType
    
    let yourEquity: Double
    let aum: Double
    let profits: Profits
    
    let currency: CurrencyType
    
    init(title: String? = nil, showActionsView: Bool? = nil) {
        type = .none
        self.title = title ?? "Total"
        self.showActionsView = showActionsView ?? false
        
        yourEquity = 2000.0
        aum = 1000.0
        profits = Profits(day: ProfitChange(value: 2000, percent: 20),
                          week: ProfitChange(value: 3000, percent: 30),
                          month: ProfitChange(value: 5000, percent: 50))
        
        currency = .usd
    }
}

struct TradingHeaderTableViewCellViewModel {
    let data: TradingHeaderData
    weak var delegate: BaseCellProtocol?
}
extension TradingHeaderTableViewCellViewModel: CellViewModel {
    func setup(on cell: TradingHeaderTableViewCell) {
        cell.configure(data, delegate: delegate)
    }
}

class TradingHeaderTableViewCell: BaseTableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var labelsView: DashboardTradingLabelsView!
    
    // MARK: - Public methods
    func configure(_ data: TradingHeaderData, delegate: BaseCellProtocol?) {
        type = .dashboardTrading
        
        self.delegate = delegate
        
        titleLabel.text = data.title
        actionsView.isHidden = !data.showActionsView
        
        labelsView.configure(data)
    }
}
