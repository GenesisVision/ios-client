//
//  ProgramInvestNowTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 01/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

struct ProgramInvestNowTableViewCellViewModel {
    let programDetailsFull: ProgramFollowDetailsFull?
    weak var investNowProtocol: InvestNowProtocol?
}

extension ProgramInvestNowTableViewCellViewModel: CellViewModel {
    func setup(on cell: InvestNowTableViewCell) {
        let programDetails = programDetailsFull?.programDetails
        
        if let isOwner = programDetailsFull?.publicInfo?.isOwnAsset, isOwner {
            cell.investButton.setTitle("Deposit", for: .normal)
        } else {
            cell.investButton.setTitle("Invest", for: .normal)
        }
        
        if let canInvest = programDetails?.personalDetails?.canInvest, programDetails?.availableInvestmentBase != 0 {
            cell.investButton.setEnabled(canInvest)
        }
        
        if let periodEnds = programDetails?.periodEnds {
            let periodEndsString = periodEnds.defaultFormatString
            cell.disclaimerLabel.text = "Your request will be processed at the end of the reporting period " + periodEndsString
        }
        
        cell.entryFeeTooltip.isHidden = false
        
        cell.investNowProtocol = investNowProtocol
        
        cell.titleLabel.text = "Invest now"
        
        
        cell.entryFeeTitleLabel.text = "Management fee"
        if let entryFeeCurrent = programDetails?.managementFeeCurrent, let entryFeeSelected = programDetails?.managementFeeSelected {
            let entryFeeCurrentString = entryFeeCurrent.rounded(with: .undefined).toString() + "%"
            let entryFeeSelectedString = " (" + entryFeeSelected.rounded(with: .undefined).toString() + "%)"
            
            cell.entryFeeValueLabel.text = entryFeeCurrent == entryFeeSelected ? entryFeeCurrentString : entryFeeCurrentString + entryFeeSelectedString
        }
        
        cell.successFeeTitleLabel.text = "success fee"
        if let successFee = programDetails?.successFeeCurrent {
            cell.successFeeValueLabel.text = successFee.rounded(with: .undefined).toString() + "%"
        }
        
        cell.investTitleLabel.text = "av. to invest"
        if let availableInvestment = programDetails?.availableInvestmentBase, let currency = programDetailsFull?.tradingAccountInfo?.currency, let currencyType = CurrencyType(rawValue: currency.rawValue) {
            cell.investValueLabel.text = availableInvestment.rounded(with: currencyType).toString() + " " + currencyType.rawValue
        }
        
        cell.editButton.isHidden = true
        
        //FIXME: if selected != current => show (selected)
        cell.stopOutTitleLabel.text = "stop out"
        if let stopOutLevel = programDetails?.stopOutLevelCurrent {
            cell.stopOutValueLabel.text = stopOutLevel.rounded(with: .undefined).toString() + "%"
        }
    }
}
