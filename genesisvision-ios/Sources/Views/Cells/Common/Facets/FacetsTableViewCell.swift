//
//  FacetsTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 19/11/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class FacetsTableViewCell: UITableViewCell {
    
    var facetsDelegateManager: FacetsDelegateManager?
    var viewModel: ListViewModelProtocolWithFacets? {
        didSet {
            if let viewModel = viewModel {
                facetsDelegateManager = FacetsDelegateManager(with: viewModel)
                collectionView.registerNibs(for: viewModel.cellModelsForRegistration)
                collectionView.delegate = facetsDelegateManager
                collectionView.dataSource = facetsDelegateManager
                collectionView.reloadData()
            }
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.indicatorStyle = .black

        contentView.backgroundColor = UIColor.BaseView.bg
        backgroundColor = UIColor.BaseView.bg
        tintColor = UIColor.Cell.title
        accessoryView?.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
    }
}
