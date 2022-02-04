//
//  PostImagesGalleryView.swift
//  genesisvision-ios
//
//  Created by Gregory on 03.02.2022.
//  Copyright © 2022 Genesis Vision. All rights reserved.
//

import UIKit

//protocol ImagesGalleryViewDelegate: AnyObject {
//    func imagePressed(index: Int, image: ImagesGalleryCollectionViewCellViewModel)
//}


class PostImagesGalleryView: UIView {
    
    private var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    var viewModels: [ImagesGalleryCollectionViewCellViewModel] = [] {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            
            collectionView.registerNibs(for: [ImagesGalleryCollectionViewCellViewModel.self])
            collectionView.registerNib(for: ImagesGalleryCollectionViewCell.self)
            collectionView.registerClass(for: ImagesGalleryCollectionViewCell.self)
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            }
            
            collectionView.reloadData()
        }
    }
    
    weak var delegate: ImagesGalleryViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        addSubview(collectionView)
        
        collectionView.fillSuperview(padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    
}

extension PostImagesGalleryView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemsCount = viewModels.count < 7 ? viewModels.count : 7
        return itemsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = viewModels[indexPath.row]
        if viewModels.count > 6 && indexPath.row == 6 {
            let remainImagesCount = viewModels.count - 6
            return collectionView.dequeueReusableCellForMoreImageButton(withModel: model, for: indexPath, remainImagesCount: remainImagesCount)
        }
        return collectionView.dequeueReusableCell(withModel: model, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellSize = CGSize(width: 100, height: 100)
        
        if viewModels.count == 1 {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        } else if viewModels.count == 2 {
            guard collectionView.frame.width > 0 else { return cellSize }
            return CGSize(width: collectionView.frame.width * 0.5 - 7, height: collectionView.frame.height)
        } else if viewModels.count == 3 {
            guard collectionView.frame.width > 0, collectionView.frame.height > 0 else { return cellSize }
            if indexPath.item == 0 {
                return CGSize(width: collectionView.frame.width - 10, height: collectionView.frame.height * 0.5 - 7)
            } else {
                return CGSize(width: collectionView.frame.width * 0.5 - 7, height: collectionView.frame.height * 0.5 - 7)
            }
        } else if viewModels.count == 4 {
            guard collectionView.frame.width > 0, collectionView.frame.height > 0 else { return cellSize }
            return CGSize(width: collectionView.frame.width * 0.5 - 7, height: collectionView.frame.height * 0.5 - 7)
        } else if viewModels.count == 5 {
            guard collectionView.frame.width > 0, collectionView.frame.height > 0 else { return cellSize }
            if indexPath.item <= 1 {
                return CGSize(width: collectionView.frame.width * 0.5 - 7, height: collectionView.frame.height * 0.5 - 7)
            } else {
                return CGSize(width: collectionView.frame.width / 3 - 7, height: collectionView.frame.height * 0.5 - 7)
            }
        } else if viewModels.count == 6 {
            guard collectionView.frame.width > 0, collectionView.frame.height > 0 else { return cellSize }
            return CGSize(width: collectionView.frame.width / 3 - 7, height: collectionView.frame.height * 0.5 - 7)
        } else if viewModels.count > 6 {
            guard collectionView.frame.width > 0, collectionView.frame.height > 0 else { return cellSize }
            if indexPath.item < 3 {
                return CGSize(width: collectionView.frame.width / 3 - 7, height: collectionView.frame.height * 0.5 - 7)
            } else {
                return CGSize(width: collectionView.frame.width / 4 - 6, height: collectionView.frame.height * 0.5 - 7)
            }
        }
        return cellSize

        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = viewModels[indexPath.row]
        delegate?.imagePressed(index: indexPath.row, image: model)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
}
