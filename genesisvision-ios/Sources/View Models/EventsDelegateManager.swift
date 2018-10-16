//
//  EventsDelegateManager.swift
//  genesisvision-ios
//
//  Created by George on 09/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UICollectionView

protocol EventsDelegateManagerProtocol: class {
    func didSelectPortfolioEvents(at indexPath: IndexPath)
}

final class EventsDelegateManager: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Variables
    weak var portfolioEventsDelegate: EventsDelegateManagerProtocol?
    
    var viewModel: EventListViewModel?
    
    let collectionTopInset: CGFloat = 0
    let collectionBottomInset: CGFloat = 0
    let collectionLeftInset: CGFloat = 10
    let collectionRightInset: CGFloat = 10
    
    // MARK: - Lifecycle
    init(with viewModel: EventListViewModel) {
        super.init()
        
        self.viewModel = viewModel
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfItems(in: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let model = viewModel?.model(at: indexPath) else {
            return UICollectionViewCell()
        }
        
        return collectionView.dequeueReusableCell(withModel: model, for: indexPath)
    }
    
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: collectionTopInset, left: collectionLeftInset, bottom: collectionBottomInset, right: collectionRightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.7, height: collectionView.frame.height - 16.0)
    }
    
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        viewModel?.didSelectPortfolioEvents(at: indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView is UITableView else { return }
        
        let yOffset = scrollView.contentOffset.y
        
        if let assetsViewController = viewModel?.router.assetsViewController,
            let pageboyDataSource = assetsViewController.pageboyDataSource {
            for controller in pageboyDataSource.controllers {
                if let vc = controller as? BaseViewControllerWithTableView {
                    vc.tableView?.isScrollEnabled = yOffset > -44.0
                }
            }
        }
    }
}

