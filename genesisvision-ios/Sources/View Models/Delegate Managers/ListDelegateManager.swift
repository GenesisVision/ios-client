//
//  ListDelegateManager.swift
//  genesisvision-ios
//
//  Created by George on 14/05/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit.UITableView

class ListDelegateManager<T: ListViewModelProtocol>: NSObject, UITableViewDelegate, UITableViewDataSource {
    var viewModel: T?
    weak var delegate: DelegateManagerProtocol?
    
    var ratingTableHeaderView: RatingTableHeaderView? {
        didSet {
            ratingTableHeaderView?.delegate = self
        }
    }
    
    init(with viewModel: T) {
        super.init()
        
        self.viewModel = viewModel
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let modelsCount = viewModel?.modelsCount(), modelsCount >= indexPath.row else {
            return
        }
        
        viewModel?.showDetail(at: indexPath)
        delegate?.delegateManagerTableView(tableView, didSelectRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = viewModel?.model(for: indexPath) else {
            return TableViewCell()
        }
        
        return tableView.dequeueReusableCell(withModel: model, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        delegate?.delegateManagerTableView(tableView, willDisplay: cell, forRowAt: indexPath)

        cell.willDisplay()
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard cellAnimations, let cell = tableView.cellForRow(at: indexPath) else { return }
        
        cell.didHighlight()
        
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        guard cellAnimations, let cell = tableView.cellForRow(at: indexPath) else { return }
        
        cell.didUnhighlight()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if viewModel?.filterModel.facetTitle == "Rating" {
            return 60.0
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if viewModel?.filterModel.facetTitle == "Rating" {
            let header = tableView.dequeueReusableHeaderFooterView() as RatingTableHeaderView
            ratingTableHeaderView = header
            
            return ratingTableHeaderView
        }
        
        return nil
    }
    
    @available(iOS 13.0, *)
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let actionProvider: UIContextMenuActionProvider = { [weak self] _ in
            return self?.viewModel?.getMenu(indexPath)
        }

        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: actionProvider)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = viewModel?.numberOfRows(in: section) ?? 0
        
        if let canPullToRefresh = viewModel?.canPullToRefresh, !canPullToRefresh {
            tableView.isScrollEnabled = numberOfRows > 0
        }
        
        return numberOfRows
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections() ?? 0
    }
}

extension ListDelegateManager: RatingTableHeaderViewProtocol {
    func levelButtonDidTap(_ level: Int) {
        var levels = [level]
        
        if let contains = viewModel?.filterModel.levelsSet?.contains(level), contains {
            levels = []
        }
            
        viewModel?.filterModel.levelsSet = levels
        viewModel?.refresh(completion: { (result) in })
    }
}
