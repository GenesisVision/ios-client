//
//  CommissionsView.swift
//  genesisvision-ios
//
//  Created by George on 30/06/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class CommissionsView: UIView {
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: TitleLabel! {
        didSet {
            titleLabel.font = UIFont.getFont(.semibold, size: 18.0)
            titleLabel.text = "Commissions"
        }
    }
    
    @IBOutlet weak var commissionsStackView: UIStackView! 
    @IBOutlet weak var totalCommissionsStackView: UIStackView! {
        didSet {
            totalCommissionsStackView.isHidden = true
        }
    }
    
    @IBOutlet weak var totalTitleLabel: TitleLabel! {
        didSet {
            totalTitleLabel.font = UIFont.getFont(.semibold, size: 16.0)
            totalTitleLabel.text = "Total"
        }
    }
    @IBOutlet weak var totalValueLabel: TitleLabel! {
        didSet {
            totalValueLabel.font = UIFont.getFont(.semibold, size: 16.0)
        }
    }
    @IBOutlet weak var totalCurrencyLabel: SubtitleLabel! {
        didSet {
            totalCurrencyLabel.font = UIFont.getFont(.regular, size: 16.0)
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.Cell.bg
    }
    
    // MARK: - Public Methods
    func configure(_ orderModel: OrderSignalModel) {
        titleLabel.text = "Commissions"
        
        if let amount = orderModel.originalCommission, let currency = orderModel.originalCommissionCurrency, let currencyType = CurrencyType(rawValue: currency) {
            addStackViews(commisionTitle: "Trading fee", amount: amount, currencyType: currencyType)
        }
        
        if let totalCommissionByType = orderModel.totalCommissionByType, !totalCommissionByType.isEmpty {
            totalCommissionByType.forEach { (commission) in
                guard let currency = commission.currency, let currencyType = CurrencyType(rawValue: currency.rawValue), let type = commission.type, let amount = commission.amount else { return }
                
                var commisionTitle = ""
                switch type {
                case .gvProgramEntry:
                    commisionTitle = "Program Entry"
                case .gvProgramSuccess:
                    commisionTitle = "Program Success"
                case .gvFundEntry:
                    commisionTitle = "Fund Entry"
                case .gvGmGvtHolderFee:
                    commisionTitle = "GM GVT Holder Fee"
                case .managerProgramEntry:
                    commisionTitle = "Manager Program Entry"
                case .managerProgramSuccess:
                    commisionTitle = "Manager Program Success"
                case .managerFundEntry:
                    commisionTitle = "Manager Fund Entry"
                case .managerFundExit:
                    commisionTitle = "Manager Fund Exit"
                case .gvWithdrawal:
                    commisionTitle = "Withdrawal"
                case .managerSignalMasterSuccessFee:
                    commisionTitle = "Manager Success Fee"
                case .managerSignalMasterVolumeFee:
                    commisionTitle = "Volume Fee"
                case .gvSignalSuccessFee:
                    commisionTitle = "Signal Success Fee"
                default:
                    break
                }
                
                addStackViews(commisionTitle: commisionTitle, amount: amount, currencyType: currencyType)
            }
            
            if let totalCommission = orderModel.totalCommission, let currency = orderModel.currency, let currencyType = CurrencyType(rawValue: currency.rawValue) {
                totalCommissionsStackView.isHidden = false
                totalValueLabel.text = totalCommission.rounded(toPlaces: 8).toString()
                totalCurrencyLabel.text = currencyType.rawValue
            }
        }
    }
    
    
    func addStackViews(commisionTitle: String, amount: Double, currencyType: CurrencyType) {
        let commisionTitleLabel = SubtitleLabel()
        commisionTitleLabel.font = UIFont.getFont(.regular, size: 16.0)
        
        commisionTitleLabel.text = commisionTitle
        let valueLabel = TitleLabel()
        valueLabel.font = UIFont.getFont(.semibold, size: 16.0)
        valueLabel.text = amount.rounded(toPlaces: 8).toString()
        let currencyLabel = SubtitleLabel()
        currencyLabel.font = UIFont.getFont(.regular, size: 16.0)
        currencyLabel.text = currencyType.rawValue
        
        let hStack = UIStackView(arrangedSubviews: [valueLabel, currencyLabel])
        hStack.axis = .horizontal
        hStack.spacing = 8.0
        hStack.alignment = .fill
        hStack.distribution = .fillProportionally
        
        let vStack = UIStackView(arrangedSubviews: [hStack])
        vStack.axis = .vertical
        vStack.spacing = 0.0
        vStack.alignment = .leading
        vStack.distribution = .fill
        
        let commissionStack = UIStackView(arrangedSubviews: [commisionTitleLabel, vStack])
        commissionStack.axis = .horizontal
        commissionStack.spacing = 8.0
        commissionStack.alignment = .center
        commissionStack.distribution = .equalSpacing
        
        commissionsStackView.addArrangedSubview(commissionStack)
    }

}
