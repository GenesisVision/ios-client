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
    var type: CellActionType
    
    var balance: Double
    var programs: Int
    var funds: Int
    
    let profits: Profits
    
    let currency: CurrencyType
    
    let isEmpty: Bool
    
    init(title: String? = nil, details: DashboardInvestingDetails?, currency: CurrencyType) {
        type = .none
        
        isEmpty = details?.events?.items?.count == 0 && details?.programsCount == 0 && details?.fundsCount == 0
        
        self.title = title ?? ""
        self.currency = currency
        
        balance = details?.equity ?? 0.0
        programs = details?.programsCount ?? 0
        funds = details?.fundsCount ?? 0
        profits = Profits(details?.profits)
    }
}

struct InvestingHeaderTableViewCellViewModel {
    let data: InvestingHeaderData
    weak var delegate: BaseTableViewProtocol?
}
extension InvestingHeaderTableViewCellViewModel: CellViewModel {
    func setup(on cell: InvestingHeaderTableViewCell) {
        cell.configure(data, delegate: delegate)
    }
}

class InvestingHeaderTableViewCell: BaseTableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var emptyView: DashboardInvestingEmptyView! {
       didSet {
           emptyView.isHidden = true
       }
    }
    @IBOutlet weak var labelsView: DashboardInvestingLabelsView!
    
    // MARK: - Public methods
    func configure(_ data: InvestingHeaderData, delegate: BaseTableViewProtocol?) {
        self.delegate = delegate
        type = .dashboardInvesting
        
        loaderView.stopAnimating()
        loaderView.isHidden = true
        
        if data.isEmpty {
            emptyView.isHidden = !data.isEmpty
            labelsView.isHidden = data.isEmpty
        }
        
        if !data.title.isEmpty {
            titleLabel.text = data.title
        } else {
            titleLabel.isHidden = true
        }

        labelsView.configure(data)
        labelsView.bottomStackView.isHidden = true
        labelsView.changeLabelsView.dayLabel.valueLabel.isHidden = true
        labelsView.changeLabelsView.weekLabel.valueLabel.isHidden = true
        labelsView.changeLabelsView.monthLabel.valueLabel.isHidden = true
    }
}

