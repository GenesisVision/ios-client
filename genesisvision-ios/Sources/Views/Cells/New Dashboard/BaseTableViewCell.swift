//
//  BaseTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 28.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit.UITableViewCell

class BaseTableViewCell: UITableViewCell, BaseTableViewCellProtocol {
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: LargeTitleLabel!
    @IBOutlet weak var actionsView: UIStackView!
    
    // MARK: - Variables
    internal var type: CellActionType = .none
    weak var delegate: BaseCellProtocol?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    // MARK: - Methods
    func setup() {
        contentView.backgroundColor = UIColor.BaseView.bg
        backgroundColor = UIColor.BaseView.bg
        tintColor = UIColor.Cell.title
        accessoryView?.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
    }
}
