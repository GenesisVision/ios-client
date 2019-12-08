//
//  WalletTableHeaderView.swift
//  genesisvision-ios
//
//  Created by George on 04/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class WalletTableHeaderView: UITableViewHeaderFooterView {
    // MARK: - Outlets
    @IBOutlet weak var separatorView: UIView! {
        didSet {
            separatorView.backgroundColor = UIColor.Common.blackSeparator
        }
    }
    
    @IBOutlet weak var totalBalanceTitleLabel: SubtitleLabel!
    @IBOutlet weak var totalBalanceValueLabel: TitleLabel! {
        didSet {
            totalBalanceValueLabel.font = UIFont.getFont(.semibold, size: 26.0)
        }
    }
    @IBOutlet weak var totalBalanceCurrencyLabel: MediumLabel!
    
    @IBOutlet weak var availableProgressView: CircularProgressView! {
        didSet {
            availableProgressView.percentTextEnable = true
            availableProgressView.foregroundStrokeColor = UIColor.Common.purple
        }
    }
    @IBOutlet weak var availableTitleLabel: SubtitleLabel!
    @IBOutlet weak var availableValueLabel: TitleLabel!
    @IBOutlet weak var availableCurrencyLabel: MediumLabel!
    
    @IBOutlet weak var investedProgressView: CircularProgressView! {
        didSet {
            investedProgressView.percentTextEnable = true
            investedProgressView.foregroundStrokeColor = UIColor.primary
            investedProgressView.clockwise = false
        }
    }
    @IBOutlet weak var investedTitleLabel: SubtitleLabel!
    @IBOutlet weak var investedValueLabel: TitleLabel!
    @IBOutlet weak var investedCurrencyLabel: MediumLabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()

        contentView.backgroundColor = UIColor.BaseView.bg
    }
    
    func configure(_ wallet: WalletSummary) {
        totalBalanceTitleLabel.text = "Total balance"
        if let totalBalanceGVT = wallet.totalBalanceGVT {
            totalBalanceValueLabel.text = totalBalanceGVT.rounded(with: .gvt).toString() + " \(Constants.gvtString)"
        }
        if let totalBalanceCurrency = wallet.totalBalanceCurrency, let selectedCurrency = CurrencyType(rawValue: getSelectedCurrency()) {
            totalBalanceCurrencyLabel.text = totalBalanceCurrency.rounded(with: selectedCurrency).toString() + " \(getSelectedCurrency())"
        }
        
        if let totalBalanceGVT = wallet.totalBalanceGVT, let availableGVT = wallet.availableGVT {
            let percent = totalBalanceGVT == 0.0 ? 0.0 : availableGVT / totalBalanceGVT
            availableProgressView.setProgress(to: percent, withAnimation: true)
        }
        
        availableTitleLabel.text = "Available"
        if let availableGVT = wallet.availableGVT {
            availableValueLabel.text = availableGVT.rounded(with: .gvt).toString() + " \(Constants.gvtString)"
        }
        if let availableCurrency = wallet.availableCurrency, let selectedCurrency = CurrencyType(rawValue: getSelectedCurrency()) {
            availableCurrencyLabel.text = availableCurrency.rounded(with: selectedCurrency).toString() + " \(getSelectedCurrency())"
        }
        
        if let totalBalanceGVT = wallet.totalBalanceGVT, let investedGVT = wallet.investedGVT {
            let percent = totalBalanceGVT == 0.0 ? 0.0 : investedGVT / totalBalanceGVT
            investedProgressView.setProgress(to: percent, withAnimation: true)
        }
        investedTitleLabel.text = "Invested value"
        if let investedGVT = wallet.investedGVT {
            investedValueLabel.text = investedGVT.rounded(with: .gvt).toString() + " \(Constants.gvtString)"
        }
        if let investedCurrency = wallet.investedCurrency, let selectedCurrency = CurrencyType(rawValue: getSelectedCurrency()) {
            investedCurrencyLabel.text = investedCurrency.rounded(with: selectedCurrency).toString() + " \(getSelectedCurrency())"
        }
    }
}
