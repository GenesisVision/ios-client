//
//  SocialPostTagsView.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 12.02.2021.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit

protocol SocialPostTagsViewDelegate: AnyObject {
    func tagPressed(tag: PostTag)
}

class SocialPostTagsView: UIView {
    
    private let mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let topButtonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let centralView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    var viewModels: [PostTag] = [] {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            
            collectionView.registerNibs(for: [SocialPostTagCollectionViewCellViewModel.self])
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .horizontal
            }
            
            collectionView.reloadData()
        }
    }
    
    weak var delegate: SocialPostTagsViewDelegate?
    
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
        
        overlayZeroLayer()
        overlayFirstLayer()
        overlaySecondLayer()
    }
    
    private func overlayZeroLayer() {
        addSubview(mainView)
        mainView.fillSuperview()
    }
    
    private func overlayFirstLayer() {
        mainView.addSubview(centralView)
        
        centralView.anchor(top: mainView.topAnchor, leading: mainView.leadingAnchor, bottom: mainView.bottomAnchor, trailing: mainView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
    }
    
    private func overlaySecondLayer() {
        centralView.addSubview(collectionView)
        
        collectionView.fillSuperview(padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    private func calculateCellWidth(model: PostTag) -> CGFloat {
        let baseWidth: CGFloat = 80
        let baseTitleWidth: CGFloat = 50
        
        guard let type = model.type else { return baseWidth }
        
        switch type {
        case .undefined:
            return baseWidth
        case .program:
            let assetTitleWidth = model.title?.width(withConstrainedHeight: 30, font: UIFont.getFont(.semibold, size: 14.0)) ?? baseTitleWidth
            return baseWidth + assetTitleWidth
        case .fund:
            let assetTitleWidth = model.title?.width(withConstrainedHeight: 30, font: UIFont.getFont(.semibold, size: 14.0)) ?? baseTitleWidth
            return baseWidth + assetTitleWidth
        case .follow:
            let assetTitleWidth = model.title?.width(withConstrainedHeight: 30, font: UIFont.getFont(.semibold, size: 14.0)) ?? baseTitleWidth
            return baseWidth + assetTitleWidth
        case .user:
            let userNameWidth = model.userDetails?.username?.width(withConstrainedHeight: 30, font: UIFont.getFont(.semibold, size: 14.0)) ?? baseTitleWidth
            return baseWidth + userNameWidth
        case .asset:
            let platformAssetNameWidth = model.platformAssetDetails?.name?.width(withConstrainedHeight: 30, font: UIFont.getFont(.semibold, size: 14.0)) ?? baseTitleWidth
            var priceWidth: CGFloat = 0
            if let price = model.platformAssetDetails?.price?.toString(), let currency = model.platformAssetDetails?.priceCurrency?.rawValue, let change = model.platformAssetDetails?.change24Percent?.toString() {
                priceWidth = (price + " " + currency + " " + change).width(withConstrainedHeight: 30, font: UIFont.getFont(.semibold, size: 14.0))
            }
            return baseWidth + max(priceWidth, platformAssetNameWidth)
        case .event:
            return baseWidth
        case .post:
            return baseWidth
        case .url:
            return baseWidth
        }
    }
}

extension SocialPostTagsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = SocialPostTagCollectionViewCellViewModel(postTag: viewModels[indexPath.row])
        return collectionView.dequeueReusableCell(withModel: model, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let model = viewModels[indexPath.row]
        
        let cellWidth = calculateCellWidth(model: model)
        
        return CGSize(width: cellWidth, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = viewModels[indexPath.row]
        delegate?.tagPressed(tag: model)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
