//
//  ProgramInvestNowTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 01/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

struct ProgramInvestNowTableViewCellViewModel {
    let programDetailsFull: ProgramDetailsFull?
    weak var investNowProtocol: InvestNowProtocol?
}

extension ProgramInvestNowTableViewCellViewModel: CellViewModel {
    func setup(on cell: InvestNowTableViewCell) {
        cell.investButton.setEnabled(false)
        
        if let canInvest = programDetailsFull?.personalProgramDetails?.canInvest, programDetailsFull?.availableInvestment != 0 {
            cell.investButton.setEnabled(canInvest)
        }
        
        if let periodEnds = programDetailsFull?.periodEnds {
            let periodEndsString = periodEnds.defaultFormatString
            cell.disclaimerLabel.text = "Your request will be processed at the end of the reporting period " + periodEndsString
        }
        
        cell.entryFeeTooltip.isHidden = false
        
        cell.investNowProtocol = investNowProtocol
        
        cell.titleLabel.text = "Invest Now"
        cell.investButton.setTitle("Invest", for: .normal)
        
        if let entryFeeCurrent = programDetailsFull?.entryFeeCurrent, let entryFeeSelected = programDetailsFull?.entryFeeSelected {
            let entryFeeCurrentString = entryFeeCurrent.rounded(withType: .undefined).toString() + "%"
            let entryFeeSelectedString = " (" + entryFeeSelected.rounded(withType: .undefined).toString() + "%)"
            
            cell.entryFeeTitleLabel.text = "entry fee"
            cell.entryFeeValueLabel.text = entryFeeCurrent == entryFeeSelected ? entryFeeCurrentString : entryFeeCurrentString + entryFeeSelectedString
        }
        
        if let successFee = programDetailsFull?.successFee {
            cell.successFeeTitleLabel.text = "success fee"
            cell.successFeeValueLabel.text = successFee.rounded(withType: .undefined).toString() + "%"
        }
        
        if let availableInvestment = programDetailsFull?.availableInvestment {
            cell.investTitleLabel.text = "av. to invest"
            cell.investValueLabel.text = availableInvestment.rounded(withType: .gvt, specialForGVT: true).toString() + " \(Constants.gvtString)"
        }
    }
}
