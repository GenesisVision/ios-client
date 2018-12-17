//
//  NotificationListViewModel.swift
//  genesisvision-ios
//
//  Created by George on 08/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableViewHeaderFooterView

final class NotificationListViewModel {
    // MARK: - Variables
    var title: String = "Notifications"
    
    var router: NotificationListRouter!
    private weak var reloadDataProtocol: ReloadDataProtocol?
    
    var allowsSelection: Bool = true
    
    var canFetchMoreResults = true
    var dataType: DataType = .api
    var notifiactionsCount: String = ""
    var skip = 0
    var take = Api.take
    var totalCount = 0 {
        didSet {
            notifiactionsCount = "\(totalCount) notifiactions"
        }
    }
    
    var viewModels = [NotificationListTableViewCellViewModel]()
    
    // MARK: - Init
    init(withRouter router: NotificationListRouter, reloadDataProtocol: ReloadDataProtocol?) {
        self.router = router
        self.reloadDataProtocol = reloadDataProtocol
    }
}

// MARK: - TableView
extension NotificationListViewModel {
    // MARK: - Public methods
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [NotificationListTableViewCellViewModel.self]
    }
    /// Return view models for registration header/footer Nib files
    var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] {
        return []
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func modelsCount() -> Int {
        return viewModels.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        return modelsCount()
    }
    
    func headerHeight(for section: Int) -> CGFloat {
        return 0.0
    }
}

// MARK: - Fetch
extension NotificationListViewModel {
    // MARK: - Public methods
    func didHighlightRowAt(at indexPath: IndexPath) -> Bool {
        guard !viewModels.isEmpty else {
            return false
        }
        
        let selectedModel = viewModels[indexPath.row]
        let notification = selectedModel.notification
        if (notification.assetId?.uuidString) != nil {
            return true
        }
        
        return false
    }
    
    func didSelectNotitifaction(at indexPath: IndexPath) {
        guard !viewModels.isEmpty else {
            return
        }
        
        let selectedModel = viewModels[indexPath.row]
        let notification = selectedModel.notification
        if let assetId = notification.assetId?.uuidString, let type = notification.assetType, let assetType = AssetType(rawValue: type.rawValue) {
            router.showAssetDetails(with: assetId, assetType: assetType)
        }
    }
    
    func fetch(completion: @escaping CompletionBlock) {
        fetch({ [weak self] (totalCount, viewModels) in
            self?.updateFetchedData(totalCount: totalCount, viewModels: viewModels)
            }, completionError: completion)
    }
    
    /// Fetch more transactions from API -> Save fetched data -> Return CompletionBlock
    func fetchMore(at row: Int) -> Bool {
        if modelsCount() - Api.fetchThreshold == row && canFetchMoreResults && modelsCount() >= take {
            fetchMore()
        }
        
        return skip < totalCount
    }
    
    func fetchMore() {
        guard skip < totalCount else { return }
        
        canFetchMoreResults = false
        fetch({ [weak self] (totalCount, viewModels) in
            var allViewModels = self?.viewModels ?? [NotificationListTableViewCellViewModel]()
            
            viewModels.forEach({ (viewModel) in
                allViewModels.append(viewModel)
            })
            
            self?.updateFetchedData(totalCount: totalCount, viewModels: allViewModels)
            }, completionError: { (result) in
                switch result {
                case .success:
                    break
                case .failure(let errorType):
                    ErrorHandler.handleError(with: errorType)
                }
        })
    }
    
    func refresh(completion: @escaping CompletionBlock) {
        skip = 0
        
        fetch({ [weak self] (totalCount, viewModels) in
            self?.updateFetchedData(totalCount: totalCount, viewModels: viewModels)
            }, completionError: completion)
    }
    
    /// Get TableViewCellViewModel for IndexPath
    func model(for index: Int) -> NotificationListTableViewCellViewModel? {
        return viewModels[index]
    }
    
    // MARK: - Private methods
    private func updateFetchedData(totalCount: Int, viewModels: [NotificationListTableViewCellViewModel]) {
        self.viewModels = viewModels
        self.totalCount = totalCount
        self.skip += self.take
        self.canFetchMoreResults = true
        self.reloadDataProtocol?.didReloadData()
    }
    
    private func fetch(_ completionSuccess: @escaping (_ totalCount: Int, _ viewModels: [NotificationListTableViewCellViewModel]) -> Void, completionError: @escaping CompletionBlock) {
        switch dataType {
        case .api:
            NotificationsDataProvider.getNotifications(skip: skip, take: take, completion: { (notificationList) in
                guard notificationList != nil else {
                    return ErrorHandler.handleApiError(error: nil, completion: completionError)
                }
                var viewModels = [NotificationListTableViewCellViewModel]()
                
                let totalCount = notificationList?.total ?? 0
                
                notificationList?.notifications?.forEach({ (notification) in
                    let viewModel = NotificationListTableViewCellViewModel(notification: notification)
                    viewModels.append(viewModel)
                })
                
                completionSuccess(totalCount, viewModels)
                completionError(.success)
            }, errorCompletion: completionError)
        case .fake:
            break
        }
    }
}



