//
//  BaseCollectionTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 14.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

struct CellWithCollectionViewModel<ViewModel: CellViewModelWithCollection> {
    var viewModel: ViewModel
    var dataSource: CollectionViewDataSource!
    
    weak var delegate: BaseTableViewProtocol?
    init(_ viewModel: ViewModel, delegate: BaseTableViewProtocol?) {
        self.viewModel = viewModel
        self.delegate = delegate
        
        dataSource = CollectionViewDataSource(viewModel)
    }
}
extension CellWithCollectionViewModel: CellViewModel {
    func setup(on cell: CellWithCollectionView) {
        cell.configure(viewModel, delegate: delegate, collectionDataSourceProtocol: dataSource, cellModelsForRegistration: viewModel.cellModelsForRegistration)
    }
}

class CellWithCollectionView: BaseTableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    // MARK: - Methods
    func configure(_ viewModel: CellViewModelWithCollection, delegate: BaseTableViewProtocol?, collectionDataSourceProtocol: CollectionDataSourceProtocol, cellModelsForRegistration: [CellViewAnyModel.Type]) {
        if viewModel.hideLoader() {
            loaderView.stopAnimating()
            loaderView.isHidden = true
        }
        
        self.type = viewModel.type
        self.delegate = delegate

        self.titleLabel.text = viewModel.title
        
        self.collectionHeightConstraint.constant = viewModel.getCollectionViewHeight()
        self.setNeedsUpdateConstraints()
        
        rightButtonsView.removeAllArrangedSubviews()
        viewModel.getRightButtons().forEach { (btn) in
            btn.titleLabel?.font = UIFont.getFont(.semibold, size: 14)
            rightButtonsView.addArrangedSubview(btn)
        }
        
        leftButtonsView.removeAllArrangedSubviews()
        viewModel.getLeftButtons().forEach { (btn) in
            leftButtonsView.addArrangedSubview(btn)
        }
        
        countLabel.isHidden = true
        if let count = viewModel.getTotalCount() {
            countLabel.isHidden = false
            countLabel.text = count.toString()
        }
        
        setupCollectionView(collectionDataSourceProtocol, cellModelsForRegistration: cellModelsForRegistration)
    }
    
    func setupCollectionView(_ collectionDataSourceProtocol: CollectionDataSourceProtocol, cellModelsForRegistration: [CellViewAnyModel.Type]) {
        
        collectionView.delegate = collectionDataSourceProtocol
        collectionView.dataSource = collectionDataSourceProtocol
        
        collectionView.isPagingEnabled = false
        
        collectionView.backgroundColor = UIColor.BaseView.bg

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout, self.type != .investingAssets {
            layout.scrollDirection = .horizontal
        } else if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout, self.type == .investingAssets {
            layout.scrollDirection = .vertical
        }
        
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.indicatorStyle = .black
        
        collectionView.registerNibs(for: cellModelsForRegistration)
        collectionView.reloadData()
    }
}

