//
//  DetailManagerTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 10/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

protocol TradingAccountActionsProtocol: class {
    func didTapDepositButton()
    func didTapWithdrawButton()
}

struct TradingAccountActionsTableViewCellViewModel {
    weak var delegate: TradingAccountActionsProtocol?
}

extension TradingAccountActionsTableViewCellViewModel: CellViewModel {
    func setup(on cell: TradingAccountActionsTableViewCell) {
        cell.delegate = delegate
    }
}

class TradingAccountActionsTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var depositButton: ActionButton! {
        didSet {
            depositButton.setTitle("Deposit", for: .normal)
        }
    }
    @IBOutlet weak var withdrawButton: ActionButton! {
        didSet {
            withdrawButton.setTitle("Withdraw", for: .normal)
            withdrawButton.configure(with: .darkClear)
        }
    }
    
    weak var delegate: TradingAccountActionsProtocol?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.BaseView.bg
        tintColor = UIColor.Cell.title
        accessoryView?.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
    }
    
    // MARK: - Actions
    @IBAction func depositButtonAction(_ sender: UIButton) {
        delegate?.didTapDepositButton()
    }
    
    @IBAction func withdrawButtonAction(_ sender: UIButton) {
        delegate?.didTapWithdrawButton()
    }
}
