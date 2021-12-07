//
//  TradeDetailView.swift
//  genesisvision-ios
//
//  Created by George on 26/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

protocol TradeDetailViewProtocol: AnyObject {
    func closeButtonDidPress()
    func cancelButtonDidPress(_ uuid: UUID)
}

class TradeDetailView: UIView {
    // MARK: - Variables
    weak var delegate: TradeDetailViewProtocol?
    
    var uuid: UUID?
    var details: OrderModel?
    
    // MARK: - Outlets
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.Cell.bg
    }
    
    // MARK: - Public Methods
    func configure(_ model: OrderModel, uuid: UUID) {
        self.uuid = uuid
        self.details = model
    }
    
    // MARK: - Actions
    @IBAction func closeButtonAction(_ sender: UIButton) {
        delegate?.closeButtonDidPress()
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        if let uuid = uuid {
            delegate?.cancelButtonDidPress(uuid)
        }
    }
}
