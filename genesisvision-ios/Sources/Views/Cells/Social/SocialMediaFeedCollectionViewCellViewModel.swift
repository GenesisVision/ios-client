//
//  SocialMediaLiveCollectionViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 13.01.2021.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit

struct SocialMediaFeedCollectionViewCellViewModel {
    let title: String
    let post: Post
}

extension SocialMediaFeedCollectionViewCellViewModel: CellViewModel {
    func setup(on cell: SocialMediaFeedCollectionViewCell) {
    }
}


class SocialMediaFeedCollectionViewCell: UICollectionViewCell {
    
    private let mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.Common.darkCell
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    
    private func setup() {
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.BaseView.bg
        contentView.addSubview(mainView)
        mainView.fillSuperview()
    }
}
