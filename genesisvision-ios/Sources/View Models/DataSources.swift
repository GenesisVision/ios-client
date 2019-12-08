//
//  DataSources.swift
//  genesisvision-ios
//
//  Created by George on 23.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class TableViewDataSource<ViewModel: ListVMProtocol>: NSObject, UITableViewDataSource, UITableViewDelegate {
    var viewModel: ViewModel
    
    init(_ viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = viewModel.numberOfRows(in: section)
        let canPullToRefresh = viewModel.canPullToRefresh
        
        if !canPullToRefresh {
            tableView.isScrollEnabled = numberOfRows > 0
        }
        
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.cell(for: indexPath, tableView: tableView)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let modelsCount = viewModel.modelsCount()
        
        guard modelsCount >= indexPath.row else {
            return
        }
        
        viewModel.didSelect(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard cellAnimations, let cell = tableView.cellForRow(at: indexPath) else { return }
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1.0, options: [.curveEaseOut, .beginFromCurrentState], animations: {
            cell.alpha = 0.8
            cell.transform = cell.transform.scaledBy(x: 0.96, y: 0.96)
        }, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        guard cellAnimations, let cell = tableView.cellForRow(at: indexPath) else { return }
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1.0, options: [.curveEaseOut, .beginFromCurrentState], animations: {
            cell.alpha = 1
            cell.transform = .identity
        }, completion: nil)
    }
}

final class CollectionViewDataSource<ViewModel: ListVMProtocol>: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var viewModel: ViewModel
    
    // MARK: - Lifecycle
    init(_ viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let model = viewModel.model(at: indexPath) else {
            return UICollectionViewCell()
        }
        
        return collectionView.dequeueReusableCell(withModel: model, for: indexPath)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        viewModel.didSelect(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.backgroundColor = UIColor.Cell.subtitle.withAlphaComponent(0.3)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.backgroundColor = UIColor.Cell.bg
        }
    }
}
