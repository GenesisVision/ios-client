//
//  SortHeaderView.swift
//  genesisvision-ios
//
//  Created by George on 19/03/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

protocol SortHeaderViewProtocol: class {
    func sortButtonDidPress()
}

class SortHeaderView: UITableViewHeaderFooterView {

    // MARK: - Variables
    weak var delegate: SortHeaderViewProtocol?
    
    // MARK: - Buttons
    @IBOutlet var sortButton: UIButton! {
        didSet {
            sortButton.setTitleColor(UIColor.Font.dark, for: .normal)
        }
    }

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor.Background.darkGray
    }
    
    // MARK: - Actions
    @IBAction func sortButtonAction(_ sender: Any) {
        delegate?.sortButtonDidPress()
    }
}
