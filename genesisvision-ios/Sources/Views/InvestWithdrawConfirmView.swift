//
//  InvestWithdrawConfirmView.swift
//  genesisvision-ios
//
//  Created by George on 15/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

struct InvestWithdrawConfirmModel {
    let title: String?
    let subtitle: String?
    
    let programLogo: UIImage?
    
    let programTitle: String?
    let managerName: String?
    
    let firstTitle: String?
    let firstValue: String?
    
    let secondTitle: String?
    let secondValue: String?
    
    let thirdTitle: String?
    let thirdValue: String?
}

protocol InvestWithdrawConfirmViewProtocol: class {
    func confirmButtonDidPress()
    func cancelButtonDidPress()
}

class InvestWithdrawConfirmView: UIView {
    // MARK: - Variables
    weak var delegate: InvestWithdrawConfirmViewProtocol?
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: TitleLabel! {
        didSet {
            titleLabel.font = UIFont.getFont(.semibold, size: 18.0)
            titleLabel.textColor = UIColor.Cell.bg
        }
    }
    @IBOutlet weak var subtitleLabel: SubtitleLabel! {
        didSet {
            subtitleLabel.textColor = UIColor.Cell.bg.withAlphaComponent(0.5)
        }
    }
    
    @IBOutlet weak var programLogoImageView: ProfileImageView!

    @IBOutlet weak var programTitleLabel: TitleLabel! {
        didSet {
            programTitleLabel.font = UIFont.getFont(.regular, size: 16.0)
            programTitleLabel.textColor = UIColor.Cell.bg
        }
    }
    @IBOutlet weak var managerNameLabel: SubtitleLabel! {
        didSet {
            managerNameLabel.font = UIFont.getFont(.semibold, size: 12.0)
            managerNameLabel.textColor = UIColor.Cell.bg.withAlphaComponent(0.4)
        }
    }
    
    @IBOutlet weak var firstTitleLabel: SubtitleLabel! {
        didSet {
            firstTitleLabel.font = UIFont.getFont(.regular, size: 12.0)
            firstTitleLabel.textColor = UIColor.Cell.bg.withAlphaComponent(0.4)
        }
    }
    @IBOutlet weak var firstValueLabel: TitleLabel! {
        didSet {
            firstValueLabel.font = UIFont.getFont(.regular, size: 16.0)
            firstValueLabel.textColor = UIColor.Cell.bg
        }
    }
    @IBOutlet weak var firstStackView: UIStackView!
    
    @IBOutlet weak var secondTitleLabel: SubtitleLabel! {
        didSet {
            secondTitleLabel.font = UIFont.getFont(.regular, size: 12.0)
            secondTitleLabel.textColor = UIColor.Cell.bg.withAlphaComponent(0.4)
        }
    }
    @IBOutlet weak var secondValueLabel: TitleLabel! {
        didSet {
            secondValueLabel.font = UIFont.getFont(.regular, size: 16.0)
            secondValueLabel.textColor = UIColor.Cell.bg
        }
    }
    @IBOutlet weak var secondStackView: UIStackView!
    
    @IBOutlet weak var thirdTitleLabel: SubtitleLabel! {
        didSet {
            thirdTitleLabel.font = UIFont.getFont(.regular, size: 12.0)
            thirdTitleLabel.textColor = UIColor.Cell.bg.withAlphaComponent(0.4)
        }
    }
    @IBOutlet weak var thirdValueLabel: TitleLabel! {
        didSet {
            thirdValueLabel.font = UIFont.getFont(.regular, size: 16.0)
            thirdValueLabel.textColor = UIColor.Cell.bg
        }
    }
    @IBOutlet weak var thirdStackView: UIStackView!
    
    @IBOutlet weak var cancelButton: ActionButton! {
        didSet {
            cancelButton.configure(with: .highClear)
        }
    }
    @IBOutlet weak var confirmButton: ActionButton!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Public Methods
    func configure(model: InvestWithdrawConfirmModel) {
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
        
        programTitleLabel.text = model.programTitle
        managerNameLabel.text = model.managerName
        
        firstTitleLabel.text = model.firstTitle
        firstValueLabel.text = model.firstValue
        
        secondTitleLabel.text = model.secondTitle
        secondValueLabel.text = model.secondValue
    
        thirdTitleLabel.text = model.thirdTitle
        thirdValueLabel.text = model.thirdValue
        
        programLogoImageView.profilePhotoImageView.image = model.programLogo
    }
    
    // MARK: - Actions
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        delegate?.cancelButtonDidPress()
    }
    
    @IBAction func confirmButtonAction(_ sender: UIButton) {
        delegate?.confirmButtonDidPress()
    }
    
}
