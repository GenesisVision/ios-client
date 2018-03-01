//
//  ProgramRequestTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 01.03.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

struct ProgramRequestTableViewCellViewModel {
    var request: InvestmentProgramRequest
    weak var delegate: ProgramRequestTableViewCellProtocol?
}

extension ProgramRequestTableViewCellViewModel: CellViewModel {
    func setup(on cell: ProgramRequestTableViewCell) {
        if let date = request.date {
            cell.dateLabel.text = date.defaultFormatString
        }
        if let status = request.status?.rawValue {
            cell.statusLabel.text = status
        }
        if let type = request.type?.rawValue {
            cell.typeLabel.text = type
        }
        if let amount = request.amount {
            cell.amountLabel.text = String(describing: amount)
        }
        if let requestID = request.id?.uuidString {
            cell.requestID = requestID
        }
        
        cell.delegate = delegate
    }
}

