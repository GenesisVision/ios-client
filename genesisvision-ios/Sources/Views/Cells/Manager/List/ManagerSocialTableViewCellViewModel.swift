//
//  ManagerSocialTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 03.03.2021.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit


struct ManagerSocialTableViewCellViewModel {
    let followersCount: Int
    let followingCount: Int
    weak var delegate: ManagerSocialTableViewCellDelegate?
}

extension ManagerSocialTableViewCellViewModel: CellViewModel {
    func setup(on cell: ManagerSocialTableViewCell) {
        
        cell.delegate = delegate
        
        cell.followrsCountLabel.text = followersCount.toString()
        cell.followingCountLabel.text = followingCount.toString()
    }
}
