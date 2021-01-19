//
//  SocialMediaListTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 15.01.2021.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit

struct SocialMediaListTableViewCellViewModel {
    let mediaPost: MediaPost
}

extension SocialMediaListTableViewCellViewModel: CellViewModel {
    func setup(on cell: SocialMediaListTableViewCell) {
        
        if let logo = mediaPost.authorLogoUrl, let fileUrl = getFileURL(fileName: logo), isPictureURL(url: fileUrl.absoluteString) {
            cell.articleAuthorImageView.kf.indicatorType = .activity
            cell.articleAuthorImageView.kf.setImage(with: fileUrl)
        } else {
            cell.articleAuthorImageView.image = UIImage.profilePlaceholder
        }
        
        if let image = mediaPost.image?.resizes?.last?.logoUrl, let fileUrl = getFileURL(fileName: image) {
            cell.postImageView.isHidden = false
            cell.postImageView.kf.indicatorType = .activity
            cell.postImageView.kf.setImage(with: fileUrl)
        } else {
            cell.postImageView.isHidden = true
        }
        
        if let userName = mediaPost.author {
            cell.authorUsernameLabel.text = userName
        }
        
        if let date = mediaPost.date {
            cell.dateLabel.text = date.dateForSocialPost
        }
        
        if let postTitle = mediaPost.title {
            cell.articleTitleLabel.text = postTitle
        }
        
        if let postText = mediaPost.text {
            cell.articleTextLabel.text = postText
        }
        
    }
}

class SocialMediaListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postImageView: UIImageView! {
        didSet {
            postImageView.contentMode = .scaleToFill
        }
    }
    
    @IBOutlet weak var articleTitleLabel: TitleLabel! {
        didSet {
            articleTitleLabel.font = UIFont.getFont(.semibold, size: 15.0)
        }
    }
    
    @IBOutlet weak var authorView: UIView! {
        didSet {
            authorView.addBorderLine(color: UIColor.Common.darkDelimiter, borderWidth: 1.0, side: .top, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
        }
    }
    
    @IBOutlet weak var articleTextLabel: TitleLabel!
    
    @IBOutlet weak var articleAuthorImageView: UIImageView! {
        didSet {
            articleAuthorImageView.backgroundColor = .clear
            articleAuthorImageView.contentMode = .scaleAspectFill
            articleAuthorImageView.image = UIImage.profilePlaceholder
            articleAuthorImageView.roundCorners()
        }
    }
    
    @IBOutlet weak var articleSourceImageVIew: UIImageView!
    @IBOutlet weak var authorUsernameLabel: TitleLabel! {
        didSet {
            authorUsernameLabel.font = UIFont.getFont(.semibold, size: 15.0)
        }
    }
    @IBOutlet weak var dateLabel: SubtitleLabel!
    
    @IBOutlet weak var bottomView: UIView! {
        didSet {
            bottomView.backgroundColor = UIColor.Common.darkCell
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.BaseView.bg
        tintColor = .clear
        accessoryView?.backgroundColor = .clear
        
        selectionStyle = .none
    }
}
