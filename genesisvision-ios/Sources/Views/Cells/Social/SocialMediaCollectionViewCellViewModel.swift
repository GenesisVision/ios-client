//
//  SocialMediaCollectionViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 13.01.2021.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit

protocol SocialMediaCollectionViewCellDelegate: class {
    func mediaPostSelected(post: MediaPost)
    func moreMediaPressed()
}

struct SocialMediaCollectionViewCellViewModel {
    let items: [MediaPost]
    weak var cellDelegate: SocialMediaCollectionViewCellDelegate?
}


extension SocialMediaCollectionViewCellViewModel: CellViewModel {
    func setup(on cell: SocialMediaCollectionViewCell) {
        cell.topButton.setTitle("Media", for: .normal)
        cell.delegate = cellDelegate
        cell.viewModels = items
    }
}

class SocialMediaCollectionViewCell: UICollectionViewCell {
    
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
    
    private let arrowImageView: UIImageView = {
        let image = UIImage(named: "img_back_arrow")
        let imageView = UIImageView(image: image)
        imageView.transform = imageView.transform.rotated(by: CGFloat(Double.pi))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let topButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.contentHorizontalAlignment = .left
        button.setTitleColor(UIColor.Common.white, for: .normal)
        button.isUserInteractionEnabled = true
        button.titleLabel?.font = UIFont.getFont(.semibold, size: 17)
        return button
    }()
    
    
    var viewModels: [MediaPost] = [] {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            
            collectionView.registerNibs(for: [SocialMediaPostCollectionViewCell.self])
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .horizontal
            }
            
            collectionView.reloadData()
        }
    }
    
    weak var delegate: SocialMediaCollectionViewCellDelegate?
    
    private var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
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
        
        topButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        
        overlayZeroLayer()
        overlayFirstLayer()
        overlaySecondLayer()
        overlayThirdLayer()
    }
    
    private func overlayZeroLayer() {
        contentView.addSubview(mainView)
        mainView.fillSuperview()
    }
    
    private func overlayFirstLayer() {
        mainView.addSubview(topButtonView)
        mainView.addSubview(centralView)
        
        topButtonView.anchor(top: mainView.topAnchor, leading: mainView.leadingAnchor, bottom: nil, trailing: mainView.trailingAnchor, size: CGSize(width: 0, height: 50))
        
        centralView.anchor(top: topButtonView.bottomAnchor, leading: mainView.leadingAnchor, bottom: mainView.bottomAnchor, trailing: mainView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
    }
    
    private func overlaySecondLayer() {
        topButtonView.addSubview(arrowImageView)
        topButtonView.addSubview(topButton)
        
        arrowImageView.anchor(top: topButtonView.topAnchor, leading: nil, bottom: topButtonView.bottomAnchor, trailing: topButtonView.trailingAnchor, padding: UIEdgeInsets(top: 19, left: 0, bottom: 19, right: 10), size: CGSize(width: 6, height: 12))
        
        topButton.anchor(top: topButtonView.topAnchor, leading: topButtonView.leadingAnchor, bottom: topButtonView.bottomAnchor, trailing: arrowImageView.leadingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
    }
    
    private func overlayThirdLayer() {
        centralView.addSubview(collectionView)
        
        collectionView.fillSuperview(padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
    }
    
    @objc private func buttonPressed(_ sender: UIButton) {
        delegate?.moreMediaPressed()
    }
}

extension SocialMediaCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = SocialMediaPostCollectionViewCellViewModel(post: viewModels[indexPath.row])
        return collectionView.dequeueReusableCell(withModel: model, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width*0.5, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = viewModels[indexPath.row]
        delegate?.mediaPostSelected(post: model)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
