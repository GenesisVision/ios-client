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
    @IBOutlet weak var countLabel: RoundedLabel! {
        didSet {
            countLabel.textColor = UIColor.primary
            countLabel.backgroundColor = UIColor.primary.withAlphaComponent(0.1)
            countLabel.font = UIFont.getFont(.semibold, size: 12)
        }
    }
    @IBOutlet weak var leftButtonsView: UIStackView!
    @IBOutlet weak var rightButtonsView: UIStackView!
    var loaderView = UIActivityIndicatorView(style: .whiteLarge)
    
    // MARK: - Variables
    internal var type: CellActionType = .none
    weak var delegate: BaseTableViewProtocol?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        loaderView.center = center
    }
    
    // MARK: - Methods
    func setup() {
        contentView.backgroundColor = UIColor.BaseView.bg
        backgroundColor = UIColor.BaseView.bg
        tintColor = UIColor.Cell.title
        accessoryView?.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
        
        loaderView.startAnimating()
        loaderView.center = center
        addSubview(loaderView)
    }
}
