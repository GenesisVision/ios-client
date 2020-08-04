//
//  ProgramHeaderTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 27.12.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit
import Kingfisher

struct FundHeaderTableViewCellViewModel {
    let details: FundDetailsFull
}

extension FundHeaderTableViewCellViewModel: CellViewModel {
    func setup(on cell: ProgramHeaderTableViewCell) {
        cell.configure(details)
    }
}

protocol ProgramHeaderProtocol: class {
    func aboutLevelButtonDidPress()
}

struct ProgramHeaderTableViewCellViewModel { 
    let details: ProgramFollowDetailsFull
    weak var delegate: ProgramHeaderProtocol?
}

extension ProgramHeaderTableViewCellViewModel: CellViewModel {
    func setup(on cell: ProgramHeaderTableViewCell) {
        cell.configure(details)
        cell.delegate = delegate
    }
}

class ProgramHeaderTableViewCell: UITableViewCell {
    weak var delegate: ProgramHeaderProtocol?
    
    @IBOutlet weak var assetLogoImageView: ProfileImageView! {
       didSet {
           assetLogoImageView.backgroundColor = UIColor.BaseView.bg
       }
    }
    @IBOutlet weak var bottomHeightConstraint: NSLayoutConstraint! {
        didSet {
            bottomHeightConstraint.constant = 68.0
        }
    }
    @IBOutlet weak var bottomView: UIView! {
        didSet {
            bottomView.backgroundColor = UIColor.BaseView.bg
        }
    }
    @IBOutlet weak var labelsStackView: UIStackView!
    @IBOutlet weak var tagsView: UIScrollView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.BaseView.bg
        
        assetLogoImageView.imageWidthConstraint.constant = 120.0
    }
 
    func animateLevelButton() {
        UIView.animate(withDuration: 0.3, animations: {
            self.assetLogoImageView.levelButton.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }, completion: { _ in
            UIView.animate(withDuration: 0.3, animations: {
                self.assetLogoImageView.levelButton.transform = CGAffineTransform.identity
            }, completion: { _ in
                self.assetLogoImageView.levelButton.layoutSubviews()
            })
        })
    }
    
    func configure(_ details: FundDetailsFull) {
        bottomHeightConstraint.constant = 0.0
        
        if let color = details.publicInfo?.color {
            assetLogoImageView.profilePhotoImageView.backgroundColor = UIColor.hexColor(color)
        }
        
        assetLogoImageView.profilePhotoImageView.image = UIImage.fundPlaceholder
        
        if let logo = details.publicInfo?.logoUrl, let fileUrl = getFileURL(fileName: logo), isPictureURL(url: fileUrl.absoluteString) {
            assetLogoImageView.profilePhotoImageView.kf.indicatorType = .activity
            assetLogoImageView.profilePhotoImageView.kf.setImage(with: fileUrl, placeholder: UIImage.fundPlaceholder)
            assetLogoImageView.profilePhotoImageView.backgroundColor = .clear
        }
        
        assetLogoImageView.levelButton.isHidden = true
    }
    
    func configure(_ details: ProgramFollowDetailsFull) {
        setupTags(details)
        
        if details.followDetails != nil {
            assetLogoImageView.levelButton.isHidden = true
        } else {
           setup(details.programDetails)
        }
        
        if let color = details.publicInfo?.color {
            assetLogoImageView.profilePhotoImageView.backgroundColor = UIColor.hexColor(color)
        }
        
        assetLogoImageView.profilePhotoImageView.image = UIImage.programPlaceholder
        
        if let logo = details.publicInfo?.logoUrl, let fileUrl = getFileURL(fileName: logo), isPictureURL(url: fileUrl.absoluteString) {
            assetLogoImageView.profilePhotoImageView.kf.indicatorType = .activity
            assetLogoImageView.profilePhotoImageView.kf.setImage(with: fileUrl, placeholder: UIImage.programPlaceholder)
            assetLogoImageView.profilePhotoImageView.backgroundColor = .clear
        }
    }
    
    func setup(_ details: ProgramDetailsFull?) {
        guard let details = details else {
            assetLogoImageView.levelButton.isHidden = true
            assetLogoImageView.profilePhotoImageView.isHidden = true
            return
        }
        
        if let level = details.level {
            if let levelProgress = details.levelProgress {
                assetLogoImageView.levelButton.progress = levelProgress
            }
            
            assetLogoImageView.levelButton.isHidden = false
            assetLogoImageView.profilePhotoImageView.isHidden = false
            assetLogoImageView.levelButton.setTitle(level.toString(), for: .normal)
        }
    }
    
    func setupTags(_ details: ProgramFollowDetailsFull) {
        labelsStackView.removeAllArrangedSubviews()
        
        if let currency = details.tradingAccountInfo?.currency {
            let label = CurrencyLabel()
            label.text = currency.rawValue
            labelsStackView.addArrangedSubview(label)
        }
        
        guard let tags = details.tags, !tags.isEmpty else { return }
        
        tags.forEach { (tag) in
            guard let name = tag.name, let color = tag.color else { return }
            let label = RoundedLabel()
            label.text = name.uppercased()
            label.backgroundColor = UIColor.hexColor(color).withAlphaComponent(0.1)
            label.textColor = UIColor.hexColor(color)
            labelsStackView.addArrangedSubview(label)
        }
    }
    
    // MARK: - Actions
    @IBAction func aboutLevelButtonAction(_ sender: UIButton) {
        delegate?.aboutLevelButtonDidPress()
    }
}
