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
        
        if let isOwner = fundDetailsFull?.publicInfo?.isOwnAsset, isOwner {
            cell.editButton.isHidden = false
            cell.editButton.setEnabled(true)
        } else {
            cell.editButton.isHidden = true
            cell.editButton.setEnabled(false)
        }
        
        cell.disclaimerLabel.isHidden = true
        
        cell.investNowProtocol = investNowProtocol
        
        cell.titleLabel.text = "Invest now"
        cell.investButton.setTitle("Invest", for: .normal)
        
         if let entryFee = fundDetailsFull?.entryFeeCurrent {
            cell.entryFeeTitleLabel.text = "Entry fee"
            cell.entryFeeValueLabel.text = entryFee.rounded(with: .undefined).toString() + "%"
        }
        
        if let exitFee = fundDetailsFull?.exitFeeCurrent {
            cell.successFeeTitleLabel.text = "exit fee"
            cell.successFeeValueLabel.text = exitFee.rounded(with: .undefined).toString() + "%"
        }
        
        cell.investStackView.isHidden = true
    }
}
