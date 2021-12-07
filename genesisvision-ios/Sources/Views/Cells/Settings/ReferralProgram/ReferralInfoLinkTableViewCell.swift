//
//  ReferralInfoLinkTableViewCell.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 28.10.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import UIKit

protocol ReferralInfoLinkTableViewCellProtocol: AnyObject {
    func shareButtonDidTap()
    func copyButtonDidTap()
}

struct ReferralInfoLinkTableViewCellViewModel {
    let link: String
    weak var delegate: ReferralInfoLinkTableViewCellProtocol?
}

extension ReferralInfoLinkTableViewCellViewModel: CellViewModel {
    func setup(on cell: ReferralInfoLinkTableViewCell) {
        
        if !link.isEmpty {
            cell.linkValueLabel.text = link
        }
        
        cell.delegate = delegate
    }
}

class ReferralInfoLinkTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: LargeTitleLabel! {
        didSet {
            titleLabel.text = "Invite your friends to Genesis Vision"
        }
    }
    
    @IBOutlet weak var linkTitleLabel: SubtitleLabel! {
        didSet {
            linkTitleLabel.font = UIFont.getFont(.regular, size: 14.0)
            linkTitleLabel.text = "Your referral link"
        }
    }
    
    @IBOutlet weak var linkValueLabel: SubtitleLabel! {
        didSet {
            linkValueLabel.font = UIFont.getFont(.regular, size: 14.0)
            linkValueLabel.textColor = UIColor.Common.primary
        }
    }
    
    @IBOutlet weak var shareButton: ActionButton! {
        didSet {
            shareButton.configure(with: .darkClear)
            shareButton.setTitle("Share", for: .normal)
        }
    }
    
    @IBOutlet weak var copyButton: ActionButton! {
        didSet {
            copyButton.setTitle("Copy", for: .normal)
        }
    }
    
    weak var delegate: ReferralInfoLinkTableViewCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func shareButtonAction(_ sender: Any) {
        delegate?.shareButtonDidTap()
    }
    
    @IBAction func copyButtonAction(_ sender: Any) {
        delegate?.copyButtonDidTap()
    }
    
}
