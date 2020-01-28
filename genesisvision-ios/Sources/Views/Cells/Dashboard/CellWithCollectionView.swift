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
    var dataSource: CollectionViewDataSource<ViewModel>!
    
    weak var delegate: BaseTableViewProtocol?
    init(_ viewModel: ViewModel, delegate: BaseTableViewProtocol?) {
        self.viewModel = viewModel
        self.delegate = delegate
        
        dataSource = CollectionViewDataSource(viewModel)
    }
}
extension CellWithCollectionViewModel: CellViewModel {
    func setup(on cell: CellWithCollectionView) {
        cell.configure(viewModel, delegate: delegate, collectionViewDelegate: dataSource, collectionViewDataSource: dataSource, cellModelsForRegistration: viewModel.cellModelsForRegistration)
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
    func configure(_ viewModel: CellViewModelWithCollection, delegate: BaseTableViewProtocol?, collectionViewDelegate: UICollectionViewDelegate, collectionViewDataSource: UICollectionViewDataSource, cellModelsForRegistration: [CellViewAnyModel.Type]) {
        if viewModel.hideLoader() {
            loaderView.stopAnimating()
            loaderView.isHidden = true
        }
        
        self.type = viewModel.type
        self.delegate = delegate

        self.titleLabel.text = viewModel.title
        
        self.collectionHeightConstraint.constant = viewModel.getCollectionViewHeight()
        
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
        
        setupCollectionView(collectionViewDelegate, collectionViewDataSource, cellModelsForRegistration: cellModelsForRegistration, layout: viewModel.makeLayout())
    }
    
    func setupCollectionView(_ collectionViewDelegate: UICollectionViewDelegate, _ collectionViewDataSource: UICollectionViewDataSource, cellModelsForRegistration: [CellViewAnyModel.Type], layout: UICollectionViewLayout) {
//        collectionView.collectionViewLayout = layout
        collectionView.delegate = collectionViewDelegate
        collectionView.dataSource = collectionViewDataSource
        
        collectionView.isPagingEnabled = false
        
        collectionView.backgroundColor = UIColor.BaseView.bg

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.indicatorStyle = .black
        
        collectionView.registerNibs(for: cellModelsForRegistration)
        collectionView.reloadData()
    }
}

