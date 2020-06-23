//
//  FundInvestNowTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 25/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

struct FundInvestNowTableViewCellViewModel {
    let fundDetailsFull: FundDetailsFull?
    weak var investNowProtocol: InvestNowProtocol?
}

extension FundInvestNowTableViewCellViewModel: CellViewModel {
    func setup(on cell: InvestNowTableViewCell) {
        if let canInvest = fundDetailsFull?.personalDetails?.canInvest {
            cell.investButton.setEnabled(canInvest)
        }
        
        cell.disclaimerLabel.isHidden = true
        
        cell.investNowProtocol = investNowProtocol
        
        cell.titleLabel.text = "Invest now"
        cell.investButton.setTitle("Invest", for: .normal)
        
         if let entryFee = fundDetailsFull?.entryFeeCurrent {
            cell.entryFeeTitleLabel.text = "Management fee"
            cell.entryFeeValueLabel.text = entryFee.rounded(with: .undefined).toString() + "%"
        }
        
        if let exitFee = fundDetailsFull?.exitFeeCurrent {
            cell.successFeeTitleLabel.text = "exit fee"
            cell.successFeeValueLabel.text = exitFee.rounded(with: .undefined).toString() + "%"
        }
        
        cell.investStackView.isHidden = true
    }
}
