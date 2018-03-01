//
//  ProgramRequestTableViewCell.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 01.03.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

protocol ProgramRequestTableViewCellProtocol: class {
    func cancelRequestDidPress(with requestID: String)
}

class ProgramRequestTableViewCell: UITableViewCell {
    // MARK: - Variables
    weak var delegate: ProgramRequestTableViewCellProtocol?
    var requestID: String = ""
    var requestStatus: String = "" {
        didSet {
            cancelButton.isHidden = requestStatus != "new"
        }
    }
    
    // MARK: - Buttons
    @IBOutlet weak var cancelButton: ActionButton!
    
    // MARK: - Labels
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.Background.main
        contentView.backgroundColor = UIColor.Background.main
    }
    
    // MARK: - Actions
    @IBAction func cancelButtonAction(_ sender: Any) {
        delegate?.cancelRequestDidPress(with: requestID)
    }

}
