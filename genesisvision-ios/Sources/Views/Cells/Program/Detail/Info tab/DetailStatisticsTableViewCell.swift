//
//  DetailStatisticsTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 30/06/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class DetailStatisticsTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var topStackView: UIStackView! {
        didSet {
            topStackView.isHidden = true
        }
    }
    @IBOutlet weak var bottomStackView: UIStackView! {
        didSet {
           bottomStackView.isHidden = true
        }
    }
    
    @IBOutlet weak var periodLabel: TitleLabel!
    @IBOutlet weak var periodStackView: UIStackView!
    @IBOutlet weak var ageLabel: TitleLabel!
    @IBOutlet weak var ageStackView: UIStackView!
    @IBOutlet weak var wpdLabel: TitleLabel!
    @IBOutlet weak var wpdStackView: UIStackView!
    @IBOutlet weak var investmentScaleLabel: TitleLabel!
    @IBOutlet weak var investmentScaleStackView: UIStackView!
    @IBOutlet weak var leverageLabel: TitleLabel!
    @IBOutlet weak var leverageStackView: UIStackView!
    @IBOutlet weak var volumeLabel: TitleLabel!
    @IBOutlet weak var volumeStackView: UIStackView!
    @IBOutlet weak var brokerLogo: UIImageView!
    @IBOutlet weak var brokerStackView: UIStackView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.BaseView.bg
        tintColor = UIColor.Cell.title
        accessoryView?.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
    }
    
    func addToStackView(_ stackView: UIStackView, value: String, header: String) {
        stackView.isHidden = false
        
        let sibtitleLabel = SubtitleLabel()
        sibtitleLabel.text = header
        sibtitleLabel.textAlignment = .left
        
        let titleLabel = TitleLabel()
        titleLabel.text = value
        titleLabel.textAlignment = .left
        
        let vStack = UIStackView(arrangedSubviews: [titleLabel, sibtitleLabel])
        vStack.axis = .vertical
        vStack.spacing = 8.0
        vStack.alignment = .leading
        vStack.distribution = .fillProportionally

        stackView.addArrangedSubview(vStack)
    }
}
