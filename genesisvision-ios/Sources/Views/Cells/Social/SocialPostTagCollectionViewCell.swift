//
//  SocialPostTagCollectionViewCell.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 12.02.2021.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit

struct SocialPostTagCollectionViewCellViewModel {
    let postTag: PostTag
}

extension SocialPostTagCollectionViewCellViewModel: CellViewModel {
    func setup(on cell: SocialPostTagCollectionViewCell) {
        guard let type = postTag.type, let title = postTag.title else { return }
        
        switch type {
        case .undefined:
            break
        case .program:
            cell.postTagTitleLabel.text = title
            cell.postTagSubtitleLabel.text = type.rawValue
            
            if let logo = postTag.assetDetails?.logoUrl, let fileUrl = getFileURL(fileName: logo) {
                cell.postTagImageView.isHidden = false
                cell.postTagImageView.kf.indicatorType = .activity
                cell.postTagImageView.kf.setImage(with: fileUrl)
            } else {
                cell.postTagImageView.image = UIImage.programPlaceholder
            }
            
            if let price = postTag.assetDetails?.price?.toString(), let currency = postTag.assetDetails?.priceCurrency?.rawValue {
                cell.postTagValueLabel.text = price + " " + currency
            }
        case .fund:
            cell.postTagTitleLabel.text = title
            cell.postTagSubtitleLabel.text = type.rawValue
            
            if let logo = postTag.assetDetails?.logoUrl, let fileUrl = getFileURL(fileName: logo) {
                cell.postTagImageView.isHidden = false
                cell.postTagImageView.kf.indicatorType = .activity
                cell.postTagImageView.kf.setImage(with: fileUrl)
            } else {
                cell.postTagImageView.image = UIImage.fundPlaceholder
            }
            
            if let price = postTag.assetDetails?.price?.toString(), let currency = postTag.assetDetails?.priceCurrency?.rawValue {
                cell.postTagValueLabel.text = price + " " + currency
            }
        case .follow:
            cell.postTagTitleLabel.text = title
            cell.postTagSubtitleLabel.text = type.rawValue
            
            if let logo = postTag.assetDetails?.logoUrl, let fileUrl = getFileURL(fileName: logo) {
                cell.postTagImageView.isHidden = false
                cell.postTagImageView.kf.indicatorType = .activity
                cell.postTagImageView.kf.setImage(with: fileUrl)
            } else {
                cell.postTagImageView.image = UIImage.programPlaceholder
            }
            
            if let price = postTag.assetDetails?.price?.toString(), let currency = postTag.assetDetails?.priceCurrency?.rawValue {
                cell.postTagValueLabel.text = price + " " + currency
            }
        case .user:
            cell.postTagTitleLabel.text = postTag.userDetails?.username
            
            if let logo = postTag.userDetails?.logoUrl, let fileUrl = getFileURL(fileName: logo) {
                cell.postTagImageView.isHidden = false
                cell.postTagImageView.kf.indicatorType = .activity
                cell.postTagImageView.kf.setImage(with: fileUrl)
            } else {
                cell.postTagImageView.image = UIImage.profilePlaceholder
            }
        case .asset:
            cell.postTagTitleLabel.text = postTag.platformAssetDetails?.name
            cell.postTagSubtitleLabel.isHidden = true
            
            if let logo = postTag.platformAssetDetails?.logoUrl, let fileUrl = getFileURL(fileName: logo) {
                cell.postTagImageView.isHidden = false
                cell.postTagImageView.kf.indicatorType = .activity
                cell.postTagImageView.kf.setImage(with: fileUrl)
            } else {
                cell.postTagImageView.isHidden = true
            }
            
            if let price = postTag.platformAssetDetails?.price?.toString(), let currency = postTag.platformAssetDetails?.priceCurrency?.rawValue {
                cell.postTagValueLabel.text = price + " " + currency
            }
            
            if let change = postTag.platformAssetDetails?.change24Percent?.toString(), let changeState = postTag.platformAssetDetails?.changeState {
                
                if changeState == .increased {
                    cell.postTagSecondValueLabel.text = "+" + change + " " + "%"
                    cell.postTagSecondValueLabel.textColor = UIColor.Common.green
                } else {
                    cell.postTagSecondValueLabel.text = change + " " + "%"
                    cell.postTagSecondValueLabel.textColor = UIColor.Common.red
                }
            }
        case .event:
            break
        case .post:
            break
        case .url:
            break
        }
    }
}

class SocialPostTagCollectionViewCell: UICollectionViewCell {
    
    private let mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.roundCorners()
        return view
    }()
    
    private let topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let postTagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage.profilePlaceholder
        return imageView
    }()
    
    let postTagTitleLabel: TitleLabel = {
        let label = TitleLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.getFont(.semibold, size: 14.0)
        return label
    }()
    
    let postTagSubtitleLabel: SubtitleLabel = {
        let label = SubtitleLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.getFont(.regular, size: 13.0)
        return label
    }()
    
    let titleSubtitleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let postTagValueLabel: TitleLabel = {
        let label = TitleLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.getFont(.semibold, size: 14.0)
        return label
    }()
    
    let postTagSecondValueLabel: TitleLabel = {
        let label = TitleLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.getFont(.semibold, size: 14.0)
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postTagSecondValueLabel.text = ""
        postTagValueLabel.text = ""
    }
    
    private func setup() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        mainView.roundCorners(with: 10, borderWidth: 1.0, borderColor: UIColor.Common.nodata)
        
        overlayZeroLayer()
        overlayFirstLayer()
        overlayTopView()
        overlayBottomView()
    }
    
    private func overlayZeroLayer() {
        contentView.addSubview(mainView)
        mainView.fillSuperview()
    }
    
    private func overlayFirstLayer() {
        mainView.addSubview(topView)
        mainView.addSubview(bottomView)
        
        topView.anchor(top: mainView.topAnchor, leading: mainView.leadingAnchor, bottom: nil, trailing: mainView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10), size: CGSize(width: 0, height: 50))
        
        bottomView.anchor(top: topView.bottomAnchor, leading: mainView.leadingAnchor, bottom: mainView.bottomAnchor, trailing: mainView.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10))
    }
    
    private func overlayTopView() {
        topView.addSubview(postTagImageView)
        topView.addSubview(titleSubtitleStackView)
        
        titleSubtitleStackView.addArrangedSubview(postTagTitleLabel)
        titleSubtitleStackView.addArrangedSubview(postTagSubtitleLabel)
        
        postTagImageView.anchor(top: nil, leading: topView.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0))
        postTagImageView.anchorCenter(centerY: topView.centerYAnchor, centerX: nil)
        postTagImageView.anchorSize(size: CGSize(width: 30, height: 30))
        postTagImageView.roundCorners(with: 15)
        
        titleSubtitleStackView.anchor(top: topView.topAnchor, leading: postTagImageView.trailingAnchor, bottom: topView.bottomAnchor, trailing: topView.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 2), size: CGSize(width: 0, height: 50))
    }
    
    private func overlayBottomView() {
        bottomView.addSubview(postTagValueLabel)
        bottomView.addSubview(postTagSecondValueLabel)
        
        postTagValueLabel.anchor(top: bottomView.topAnchor, leading: bottomView.leadingAnchor, bottom: bottomView.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 5, bottom: 10, right: 5), size: CGSize(width: 0, height: 30))
        
        postTagSecondValueLabel.anchor(top: bottomView.topAnchor, leading: postTagValueLabel.trailingAnchor, bottom: bottomView.bottomAnchor, trailing: bottomView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 5, bottom: 10, right: 5), size: CGSize(width: 0, height: 30))
    }

}
