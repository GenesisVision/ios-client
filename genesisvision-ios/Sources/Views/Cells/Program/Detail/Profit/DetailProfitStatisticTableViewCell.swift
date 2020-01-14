//
//  DetailProfitStatisticTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 01/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class DetailProfitStatisticTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = UIColor.Cell.title
            titleLabel.font = UIFont.getFont(.semibold, size: 18.0)
        }
    }
    
    @IBOutlet weak var stackView: UIStackView! {
        didSet {
            stackView.isHidden = true
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
    }
    
    func addToStackView(_ value: String, header: String) {
        stackView.isHidden = false
        
        let sibtitleLabel = SubtitleLabel()
        sibtitleLabel.text = header
        sibtitleLabel.textAlignment = .left
        
        let titleLabel = TitleLabel()
        titleLabel.text = value
        titleLabel.textAlignment = .right
        
        let hStack = UIStackView(arrangedSubviews: [sibtitleLabel, titleLabel])
        hStack.axis = .horizontal
        hStack.spacing = 8.0
        hStack.alignment = .fill
        hStack.distribution = .fillEqually

        stackView.addArrangedSubview(hStack)
    }
}
