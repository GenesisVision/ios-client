//
//  DashboardProgramListDelegateManager.swift
//  genesisvision-ios
//
//  Created by George on 12/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableView

final class DashboardProgramListDelegateManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var viewModel: DashboardProgramListViewModel?
    
    init(with viewModel: DashboardProgramListViewModel) {
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
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = viewModel?.model(at: indexPath) else {
            return TableViewCell()
        }
        
        return tableView.dequeueReusableCell(withModel: model, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        showInfiniteIndicator(value: viewModel?.fetchMore(at: indexPath.row))
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows(in: section) ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections() ?? 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        print("scrollViewDidScrollToTop")
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("scrollViewDidEndScrollingAnimation")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("remove finger")
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        print("scrollViewDidZoom")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("iOS stoped table view")
    }
    
    func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        print("scrollViewDidChangeAdjustedContentInset")
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        print("scrollViewDidEndZooming")
    }
}
