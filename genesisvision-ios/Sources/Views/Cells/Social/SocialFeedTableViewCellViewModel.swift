//
//  SocialFeedTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 17.11.2021.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit

struct SocialFeedTableViewCellViewModel {
    let post: Post
    weak var cellDelegate: SocialFeedCollectionViewCellDelegate?
}


extension SocialFeedTableViewCellViewModel: CellViewModel {
    func setup(on cell: SocialFeedTableViewCell) {
    }
}


class SocialFeedTableViewCell: UITableViewCell {
    
}
