//
//  EventListViewModel.swift
//  genesisvision-ios
//
//  Created by George on 24/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UICollectionView

protocol PortfolioEventsDelegate: class {
    func didSelectPortfolioEvents(at indexPath: IndexPath)
}

class EventListViewModel {
    enum SectionType {
        case eventList
    }
    
    // MARK: - Variables
    var title = "Portfolio Events"
    
    private var sections: [SectionType] = [.eventList]
    
    var portfolioEventsDelegate: PortfolioEventsDelegate?
    var router: DashboardRouter!
    private var dashboard: InvestorDashboard?
    
    private weak var reloadDataProtocol: ReloadDataProtocol?
    
    var dateRangeType: DateRangeType?
    var dateRangeFrom: Date?
    var dateRangeTo: Date?
    
    var canFetchMoreResults = true
    var skip = 0
    var take = Constants.Api.take
    var totalCount = 0
    
    var bottomViewType: BottomViewType {
        return .none
    }
    
    var viewModels = [DashboardTableViewCellViewModel]()
    
    init(withRouter router: DashboardRouter) {
        self.router = router
    }
    
    // MARK: - Public methods
    func didSelectPortfolioEvents(at indexPath: IndexPath) {
        guard !viewModels.isEmpty else {
            return
        }
        
        let selectedModel = viewModels[indexPath.row]
        if let programID = selectedModel.investmentProgram.id?.uuidString {
            router.showProgramDetails(with: programID)
        }
    }
    
    func showAllPortfolioEvents() {
        router.show(routeType: .allPortfolioEvents)
    }
}

extension EventListViewModel {
    // MARK: - Public methods
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [DashboardTableViewCellViewModel.self]
    }
    
    func modelsCount() -> Int {
        return viewModels.count
    }
    
    func numberOfSections() -> Int {
        return modelsCount() > 0 ? sections.count : 1
    }
    
    func numberOfItems(in section: Int) -> Int {
        return modelsCount()
    }
    
    func headerTitle(for section: Int) -> String? {
        return nil
    }
}

final class EventsDelegateManager: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    weak var portfolioEventsDelegate: PortfolioEventsDelegate?
    
    var viewModel: EventListViewModel?
    
    let collectionTopInset: CGFloat = 0
    let collectionBottomInset: CGFloat = 0
    let collectionLeftInset: CGFloat = 10
    let collectionRightInset: CGFloat = 10
    
    init(with viewModel: EventListViewModel) {
        super.init()
        
        self.viewModel = viewModel
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30//viewModel?.numberOfItems(in: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PortfolioEventCollectionViewCell", for: indexPath as IndexPath) as! PortfolioEventCollectionViewCell
        return cell
    }
    
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: collectionTopInset, left: collectionLeftInset, bottom: collectionBottomInset, right: collectionRightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.6, height: collectionView.frame.height - 16.0)
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
        
        portfolioEventsDelegate?.didSelectPortfolioEvents(at: indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView is UITableView else { return }
        
        let yOffset = scrollView.contentOffset.y
        
        if let assetsViewController = viewModel?.router.assetsViewController,
            let pageboyDataSource = assetsViewController.pageboyDataSource,
            let controllers = pageboyDataSource.controllers {
            for controller in controllers {
                if let vc = controller as? BaseViewControllerWithTableView {
                    vc.tableView?.isScrollEnabled = yOffset > -44.0
                }
            }
        }
    }
}
