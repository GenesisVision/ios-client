//
//  ProgramPeriodTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 01/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class ProgramPeriodTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var progressView: UIProgressView! {
        didSet {
            progressView.progressTintColor = UIColor.ProgressView.progressTint
            progressView.trackTintColor = UIColor.ProgressView.trackTint
        }
    }
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = UIColor.Cell.subtitle
            titleLabel.font = UIFont.getFont(.semibold, size: 14.0)
            titleLabel.text = ""
        }
    }
    @IBOutlet weak var durationLabel: UILabel! {
        didSet {
            durationLabel.textColor = UIColor.Cell.title
            durationLabel.font = UIFont.getFont(.semibold, size: 14.0)
            durationLabel.text = ""
        }
    }
    @IBOutlet weak var periodLeftLabel: UILabel! {
        didSet {
            periodLeftLabel.textColor = UIColor.Cell.title
            periodLeftLabel.font = UIFont.getFont(.semibold, size: 14.0)
            periodLeftLabel.text = ""
        }
    }
    @IBOutlet weak var ageStackView: LabelWithTitle!
    @IBOutlet weak var ageProgressView: CircularProgressView!
    @IBOutlet weak var ageTitleLabel: SubtitleLabel!
    @IBOutlet weak var ageValueLabel: TitleLabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
    }
}
