//
//  ImagesGalleryView.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 20.12.2021.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit

protocol ImagesGalleryViewDelegate: AnyObject {
    func imagePressed(index: Int, image: ImagesGalleryCollectionViewCellViewModel)
}


class ImagesGalleryView: UIView {
    
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
                layout.scrollDirection = .horizontal
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

extension ImagesGalleryView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = viewModels[indexPath.row]
        return collectionView.dequeueReusableCell(withModel: model, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = viewModels[indexPath.row]

        if let width = model.resize?.width, let height = model.resize?.height,
           CGFloat(width) < collectionView.frame.width*0.5, CGFloat(height) < collectionView.frame.height {
            return CGSize(width: width, height: height)
        }

        if viewModels.count == 1 {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        } else if viewModels.count == 2 {
            return CGSize(width: collectionView.frame.width*0.5, height: collectionView.frame.height)
        } else if viewModels.count >= 3 {
            return CGSize(width: collectionView.frame.width*0.5, height: collectionView.frame.height*0.5 - 20)
        }
        
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = viewModels[indexPath.row]
        delegate?.imagePressed(index: indexPath.row, image: model)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
