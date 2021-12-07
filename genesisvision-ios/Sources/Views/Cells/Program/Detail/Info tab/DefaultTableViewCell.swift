//
//  DefaultTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 18/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

protocol EditInfoProtocol: AnyObject {
    func ditTapEditInfoButton()
}

class DefaultTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var titleLabel: SubtitleLabel! {
        didSet {
            titleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet weak var subtitleLabel: TitleLabel! {
        didSet {
            subtitleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet weak var editInfoButton: ActionButton! {
        didSet {
            editInfoButton.configure(with: .custom(options: ActionButtonOptions(borderWidth: 0, borderColor: nil, fontSize: 16, bgColor: .clear, textColor: UIColor.primary, image: nil, rightPosition: true)))
            editInfoButton.isHidden = true
        }
    }
    
    weak var editInfoProtocolDelegate: EditInfoProtocol?
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
    }
    @IBAction func editInfoButtonAction(_ sender: Any) {
        editInfoProtocolDelegate?.ditTapEditInfoButton()
    }
}
