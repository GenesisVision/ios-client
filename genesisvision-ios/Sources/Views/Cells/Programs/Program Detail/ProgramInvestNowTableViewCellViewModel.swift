//
//  ProgramInvestNowTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 01/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

struct ProgramInvestNowTableViewCellViewModel {
    let entryFee: Double?
    let successFee: Double?
    let availableInvestment: Double?
    let periodEnds: Date?
    
    weak var programInvestNowProtocol: ProgramInvestNowProtocol?
}

extension ProgramInvestNowTableViewCellViewModel: CellViewModel {
    func setup(on cell: ProgramInvestNowTableViewCell) {
        cell.programInvestNowProtocol = programInvestNowProtocol
        
        cell.titleLabel.text = "Invest Now"
        cell.investButton.setTitle("Invest", for: .normal)
        
         if let entryFee = entryFee {
            cell.entryFeeTitleLabel.text = "entry fee"
            cell.entryFeeValueLabel.text = entryFee.toString() + "%"
        }
        
        if let successFee = successFee {
            cell.successFeeTitleLabel.text = "success invest"
            cell.successFeeValueLabel.text = successFee.toString() + "%"
        }
        
        if let availableInvestment = availableInvestment {
            cell.investTitleLabel.text = "av. to invest"
            cell.investValueLabel.text = availableInvestment.rounded(withType: .gvt).toString() + " GVT"
        }
        
        if let periodEnds = periodEnds {
            cell.investDescriptionLabel.text = "Your request will be processed at the end of the reporting period \(periodEnds.defaultFormatString)"
        }
    }
}
