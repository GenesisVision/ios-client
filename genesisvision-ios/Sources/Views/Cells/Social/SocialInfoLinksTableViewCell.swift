//
//  SocialInfoLinksTableViewCell.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 19.11.2021.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit

protocol SocialInfoLinksTableViewCellDelegate: AnyObject {
    func socialLinkPressed(link: String)
}

struct SocialInfoLinksTableViewCellViewModel {
    let socialLinks: [SocialLinkViewModel]
    weak var delegate: SocialInfoLinksTableViewCellDelegate?
}

extension SocialInfoLinksTableViewCellViewModel: CellViewModel {
    func setup(on cell: SocialInfoLinksTableViewCell) {
        cell.viewModels = socialLinks
        cell.delegate = delegate
    }
}

class SocialInfoLinksTableViewCell: UITableViewCell {
    
    private let mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.backgroundColor = .clear
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.registerNibs(for: [SocialLinksCollectionViewCell.self])
        }
    }
    
    
//    private var collectionView: UICollectionView = {
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.backgroundColor = .clear
//        collectionView.showsHorizontalScrollIndicator = false
//        return collectionView
//    }()
    
    var viewModels: [SocialLinkViewModel] = [] {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            
            collectionView.registerNibs(for: [SocialLinksCollectionViewCell.self])
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .horizontal
            }
            
            collectionView.reloadData()
        }
    }
    
    weak var delegate: SocialInfoLinksTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    private func setup() {
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
    }
}


extension SocialInfoLinksTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = SocialLinksCollectionViewCellViewModel(logoUrl: viewModels[indexPath.row].logoUrl ?? "")
        return collectionView.dequeueReusableCell(withModel: model, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = viewModels[indexPath.row]
        delegate?.socialLinkPressed(link: model.logoUrl ?? "")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
