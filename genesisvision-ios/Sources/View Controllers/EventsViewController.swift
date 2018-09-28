//
//  EventsViewController.swift
//  genesisvision-ios
//
//  Created by George on 17/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class EventsViewController: BaseViewController {
    // MARK: - Variables
    var viewModel: EventListViewModel!
    
    @IBOutlet weak var headerLabel: UILabel! {
        didSet {
            headerLabel.font = UIFont.getFont(.semibold, size: 19)
        }
    }
    @IBOutlet weak var showAllButton: UIButton! {
        didSet {
            showAllButton.setTitleColor(UIColor.Cell.title, for: .normal)
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if let viewModel = viewModel {
            headerLabel.text = viewModel.title
        }
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        collectionView.register(UINib.init(nibName: "PortfolioEventCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PortfolioEventCollectionViewCell")
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.delegate = viewModel.eventsDelegateManager
        collectionView.dataSource = viewModel.eventsDelegateManager
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - Public methods
    // MARK: - Private methods
    // MARK: - Actions
    @IBAction func showAllButtonAction(_ sender: UISwitch) {
        viewModel.showAllPortfolioEvents()
    }
}
