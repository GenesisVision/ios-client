//
//  BaseCollectionTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 14.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

struct CellWithCollectionViewModel<ViewModel: ViewModelWithCollection> {
    var viewModel: ViewModel
    var dataSource: CollectionViewDataSource<ViewModel>!
    
    weak var delegate: BaseCellProtocol?
    init(_ viewModel: ViewModel, delegate: BaseCellProtocol?) {
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
    func configure(_ viewModel: ViewModelWithCollection, delegate: BaseCellProtocol?, collectionViewDelegate: UICollectionViewDelegate, collectionViewDataSource: UICollectionViewDataSource, cellModelsForRegistration: [CellViewAnyModel.Type]) {
        self.type = viewModel.type
        self.delegate = delegate

        self.titleLabel.text = viewModel.title
        self.actionsView.isHidden = !viewModel.showActionsView
        
        self.collectionHeightConstraint.constant = viewModel.getCollectionViewHeight()
        
        actionsView.removeAllArrangedSubviews()
        
        viewModel.getActions().forEach { (btn) in
            btn.titleLabel?.font = UIFont.getFont(.semibold, size: 14)
            actionsView.addArrangedSubview(btn)
        }
        
        setupCollectionView(collectionViewDelegate, collectionViewDataSource, cellModelsForRegistration: cellModelsForRegistration, layout: viewModel.makeLayout())
    }
    
    func setupCollectionView(_ collectionViewDelegate: UICollectionViewDelegate, _ collectionViewDataSource: UICollectionViewDataSource, cellModelsForRegistration: [CellViewAnyModel.Type], layout: UICollectionViewLayout) {
        collectionView.collectionViewLayout = layout
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

