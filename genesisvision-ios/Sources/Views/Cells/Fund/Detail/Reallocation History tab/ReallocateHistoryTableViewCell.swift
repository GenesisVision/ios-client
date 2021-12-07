//
//  ReallocateHistoryTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 21/07/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

protocol ReallocateHistoryTableViewCellProtocol: AnyObject {
    func didTapSeeAllButton(_ index: Int)
}

class ReallocateHistoryTableViewCell: UITableViewCell {
    // MARK: - Labels
    var index: Int?
    
    weak var delegate: ReallocateHistoryTableViewCellProtocol?
    
    @IBOutlet  weak var dateLabel: SubtitleLabel!
    @IBOutlet weak var seeAllButton: UIButton! {
        didSet {
            seeAllButton.setTitleColor(UIColor.Common.white, for: .normal)
            seeAllButton.titleLabel?.font = UIFont.getFont(.regular, size: 16.0)
            seeAllButton.isHidden = true
        }
    }
    @IBOutlet weak var stackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
    }
    
    @IBAction func seeAllButtonAction(_ sender: UIButton) {
        guard let index = index else { return }
        delegate?.didTapSeeAllButton(index)
    }
}
