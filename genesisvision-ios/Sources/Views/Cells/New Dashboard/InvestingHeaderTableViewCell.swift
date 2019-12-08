//
//  InvestingHeaderTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 25.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

struct InvestingHeaderData: BaseData {
    var title: String
    var showActionsView: Bool
    var type: CellActionType
    
    let balance: Double
    let programs: Double
    let funds: Double
    
    let profits: Profits
    
    let currency: CurrencyType
    
    init(title: String? = nil, showActionsView: Bool? = nil) {
        self.title = title ?? "Total"
        self.showActionsView = showActionsView ?? false
        self.type = .none
        
        balance = 2000.0
        programs = 1000.0
        funds = 1000.0
        
        profits = Profits(day: ProfitChange(value: 2000, percent: 20),
                          week: ProfitChange(value: 3000, percent: 30),
                          month: ProfitChange(value: 5000, percent: 50))
        
        currency = .usd
    }
}

struct InvestingHeaderTableViewCellViewModel {
    let data: InvestingHeaderData
    weak var delegate: BaseCellProtocol?
}
extension InvestingHeaderTableViewCellViewModel: CellViewModel {
    func setup(on cell: InvestingHeaderTableViewCell) {
        cell.configure(data, delegate: delegate)
    }
}

class InvestingHeaderTableViewCell: BaseTableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var labelsView: DashboardInvestingLabelsView!
    
    // MARK: - Public methods
    func configure(_ data: InvestingHeaderData, delegate: BaseCellProtocol?) {
        self.delegate = delegate
        type = .none
        
        titleLabel.text = data.title
        actionsView.isHidden = !data.showActionsView
        
        labelsView.configure(data)
    }
}

