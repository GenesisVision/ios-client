//
//  ProgramRequestTableViewCell.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 01.03.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

protocol ProgramRequestTableViewCellProtocol: class {
    func cancelRequestDidPress(with requestID: String, lastRequest: Bool)
}

class ProgramRequestTableViewCell: PlateTableViewCell {
    // MARK: - Variables
    weak var delegate: ProgramRequestTableViewCellProtocol?
    var lastRequest: Bool = false
    var requestID: String = ""
    var requestStatus: String = "" {
        didSet {
            cancelButton.isHidden = requestStatus != "new"
        }
    }
    
    // MARK: - Buttons
    @IBOutlet weak var cancelButton: UIButton! {
        didSet {
            cancelButton.setImage(#imageLiteral(resourceName: "img_cancel"), for: .normal)
            cancelButton.tintColor = UIColor.Font.red
        }
    }
    
    // MARK: - Labels
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = UIColor.BaseView.bg
    }
    
    // MARK: - Actions
    @IBAction func cancelButtonAction(_ sender: Any) {
        delegate?.cancelRequestDidPress(with: requestID, lastRequest: lastRequest)
    }

}
