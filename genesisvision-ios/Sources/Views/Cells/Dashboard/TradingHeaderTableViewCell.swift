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
    var type: CellActionType
    
    var yourEquity: Double
    var aum: Double
    var profits: Profits
    var showCreateFundButton: Bool
    var showCreateAccountButton: Bool
    
    let currency: CurrencyType
    
    let isEmpty: Bool
    
    init(title: String? = nil, details: DashboardTradingDetails?, currency: CurrencyType, showCreateFund: Bool, showCreateAccount: Bool) {
        type = .none
        self.title = title ?? ""
        
        isEmpty = details?.events?.items?.count == 0 && details?.total == 0.0 && details?.aum == 0.0
        
        self.currency = currency
        yourEquity = details?.equity ?? 0.0
        aum = details?.aum ?? 0.0
        profits = Profits(details?.profits)
        showCreateFundButton = showCreateFund
        showCreateAccountButton = showCreateAccount
    }
}

struct TradingHeaderTableViewCellViewModel {
    let data: TradingHeaderData
    weak var delegate: BaseTableViewProtocol?
    weak var createsDelegate: DashBoardTradingTableViewCellButtonsActionsProtocol?
}
extension TradingHeaderTableViewCellViewModel: CellViewModel {
    func setup(on cell: TradingHeaderTableViewCell) {
        cell.configure(data, delegate: delegate, createsDelegate: createsDelegate)
    }
}

class TradingHeaderTableViewCell: BaseTableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var emptyView: DashboardTradingEmptyView! {
       didSet {
           emptyView.isHidden = true
       }
    }
    @IBOutlet weak var labelsView: DashboardTradingLabelsView!
    weak var createsDelegate: DashBoardTradingTableViewCellButtonsActionsProtocol?
    
    // MARK: - Public methods
    func configure(_ data: TradingHeaderData, delegate: BaseTableViewProtocol?, createsDelegate: DashBoardTradingTableViewCellButtonsActionsProtocol?) {
        self.delegate = delegate
        self.createsDelegate = createsDelegate
        type = .dashboardTrading
        
        loaderView.stopAnimating()
        loaderView.isHidden = true
        
        if data.showCreateFundButton || data.showCreateAccountButton {
            emptyView.isHidden = false
            emptyView.createAccountButton.isHidden = !data.showCreateAccountButton
            emptyView.createAccountLabel.isHidden = !data.showCreateAccountButton
            emptyView.createFundButton.isHidden = !data.showCreateFundButton
            emptyView.createFundLabel.isHidden = !data.showCreateFundButton
        }
        
        if data.isEmpty {
            emptyView.isHidden = !data.isEmpty
            labelsView.isHidden = data.isEmpty
        }
        
        if !data.title.isEmpty {
            titleLabel.isHidden = false
            titleLabel.text = data.title
        } else {
            titleLabel.isHidden = true
        }
        
        labelsView.configure(data)
        labelsView.yourEquityLabel.titleLabel.isHidden = true
        labelsView.yourEquityLabel.valueLabel.textAlignment = .center
        labelsView.changeLabelsView.dayLabel.valueLabel.isHidden = true
        labelsView.changeLabelsView.weekLabel.valueLabel.isHidden = true
        labelsView.changeLabelsView.monthLabel.valueLabel.isHidden = true
    }
    
    @IBAction func createFundButtonAction(_ sender: Any) {
        createsDelegate?.createFund()
    }
    @IBAction func createAccountButtonAction(_ sender: Any) {
        createsDelegate?.createAccount()
    }
}
