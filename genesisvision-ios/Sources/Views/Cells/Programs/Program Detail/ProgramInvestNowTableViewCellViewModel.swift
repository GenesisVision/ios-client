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
    weak var programInvestNowProtocol: ProgramInvestNowProtocol?
}

extension ProgramInvestNowTableViewCellViewModel: CellViewModel {
    func setup(on cell: ProgramInvestNowTableViewCell) {
        cell.investButton.setEnabled(false)
        
        if let canInvest = programDetailsFull?.personalProgramDetails?.canInvest {
            cell.investButton.setEnabled(canInvest)
        }
        
        if let currency = programDetailsFull?.currency, let periodEnds = programDetailsFull?.periodEnds {
             cell.disclaimerLabel.text = "After clicking the \"Confirm\" button, the invested GVT will be immediately converted to \(currency.rawValue). Accrual of \(currency.rawValue) to the account manager will only occur at the end of the reporting period \(periodEnds.defaultFormatString)."
        }
        
        cell.programInvestNowProtocol = programInvestNowProtocol
        
        cell.titleLabel.text = "Invest Now"
        cell.investButton.setTitle("Invest", for: .normal)
        
         if let entryFee = programDetailsFull?.entryFee {
            cell.entryFeeTitleLabel.text = "entry fee"
            cell.entryFeeValueLabel.text = entryFee.rounded(toPlaces: 2).toString() + "%"
        }
        
        if let successFee = programDetailsFull?.successFee {
            cell.successFeeTitleLabel.text = "success fee"
            cell.successFeeValueLabel.text = successFee.rounded(toPlaces: 2).toString() + "%"
        }
        
        if let availableInvestment = programDetailsFull?.availableInvestment {
            cell.investTitleLabel.text = "av. to invest"
            cell.investValueLabel.text = availableInvestment.rounded(withType: .gvt).toString() + " \(Constants.gvtString)"
        }
    }
}
