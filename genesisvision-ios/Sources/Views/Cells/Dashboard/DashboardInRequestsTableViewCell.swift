//
//  DashboardInRequestsTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 13/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class DashboardInRequestsTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet var iconImageView: UIImageView! {
        didSet {
            iconImageView.roundWithBorder(2.0, color: UIColor.Cell.bg)
        }
    }
    
    @IBOutlet var typeImageView: UIImageView! {
        didSet {
            typeImageView.roundCorners()
        }
    }
    
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.getFont(.regular, size: 17.0)
            titleLabel.textColor = UIColor.Cell.title
        }
    }
    
    @IBOutlet var typeLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.getFont(.regular, size: 17.0)
            titleLabel.textColor = UIColor.Cell.title
        }
    }
    
    @IBOutlet var balanceValueLabel: UILabel! {
        didSet {
            balanceValueLabel.font = UIFont.getFont(.bold, size: 27.0)
            balanceValueLabel.textColor = UIColor.Cell.title
        }
    }
    
    @IBOutlet var dateLabel: UILabel! {
        didSet {
            dateLabel.font = UIFont.getFont(.regular, size: 13.0)
            dateLabel.textColor = UIColor.Cell.subtitle
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = UIColor.Cell.bg
        backgroundColor = UIColor.Cell.bg
        tintColor = UIColor.Cell.title
        accessoryView?.backgroundColor = UIColor.Cell.bg
        
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for subview in self.subviews {
            print(String(describing: subview))
            for subview1 in subview.subviews {
                print(String(describing: subview1))
                for subview2 in subview1.subviews {
                    print(String(describing: subview2))
                    for sub in subview2.subviews {
                        print(String(describing: sub))
                        if String(describing: sub).range(of: "UITableViewCellActionButton") != nil {
                            for view in sub.subviews {
                                view.backgroundColor = UIColor.Cell.redTitle.withAlphaComponent(10.0)
                                if String(describing: view).range(of: "UIButtonLabel") != nil {
                                    if let label = view as? UILabel {
                                        label.textColor = UIColor.Cell.redTitle
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
