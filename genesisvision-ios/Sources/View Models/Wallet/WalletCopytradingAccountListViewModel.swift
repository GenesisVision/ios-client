//
//  WalletCopytradingAccountListViewModel.swift
//  genesisvision-ios
//
//  Created by George on 25/02/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit.UITableViewHeaderFooterView

final class WalletCopytradingAccountListViewModel: WalletListViewModelProtocol {
    enum SectionType {
        case header
        case accounts
    }
    
    // MARK: - Variables
    var title: String = "Copytrading accounts"
    
    var wallet: WalletData?
    
    private var sections: [SectionType] = [.accounts]
    
    private var router: WalletRouter!
    private var accounts = [WalletCopytradingAccountTableViewCellViewModel]()
    private weak var reloadDataProtocol: ReloadDataProtocol?
    
    var canFetchMoreResults = true
    var dataType: DataType = .api
    var skip = 0            //offset
    var take = ApiKeys.take
    var totalCount = 0      //total count of programs
    
    // MARK: - Init
    init(withRouter router: WalletRouter, reloadDataProtocol: ReloadDataProtocol?, wallet: WalletData? = nil) {
        self.router = router
        self.reloadDataProtocol = reloadDataProtocol
        self.wallet = wallet
    }
}

// MARK: - TableView
extension WalletCopytradingAccountListViewModel {
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [WalletCopytradingAccountTableViewCellViewModel.self]
    }
    
    /// Return view models for registration header/footer Nib files
    var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] {
        return []
    }
    
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        switch sections[section] {
        case .header:
            return 0
        case .accounts:
            return accounts.count
        }
    }
    
    func headerTitle(for section: Int) -> String? {
        switch sections[section] {
        case .accounts:
            return "Copytrading accounts"
        case .header:
            return nil
        }
    }
    
    func headerHeight(for section: Int) -> CGFloat {
        switch sections[section] {
        case .header:
            return 0.0
        case .accounts:
            return 78.0
        }
    }
    
    /// Get TableViewCellViewModel for IndexPath
    func model(at indexPath: IndexPath) -> CellViewAnyModel? {
        let type = sections[indexPath.section]
        switch type {
        case .header:
            return nil
        case .accounts:
            return accounts[indexPath.row]
        }
    }
}

// MARK: - Fetch
extension WalletCopytradingAccountListViewModel {
    func fetch(completion: @escaping CompletionBlock) {
        fetch({ [weak self] (totalCount, viewModels) in
            self?.updateFetchedData(totalCount: totalCount, viewModels)
            completion(.success)
            }, completionError: completion)
        
    }
    
    func fetchMore(at indexPath: IndexPath) -> Bool {
        if numberOfRows(in: indexPath.section) - ApiKeys.fetchThreshold == indexPath.row && canFetchMoreResults && accounts.count >= take {
            fetchMore()
        }
        
        return skip < totalCount
    }
    
    func fetchMore() {
        guard skip < totalCount else { return }
        
        canFetchMoreResults = false
        fetch({ [weak self] (totalCount, viewModels) in
            var allViewModels = self?.accounts ?? [WalletCopytradingAccountTableViewCellViewModel]()
            
            viewModels.forEach({ (viewModel) in
                allViewModels.append(viewModel)
            })
            
            self?.updateFetchedData(totalCount: totalCount, allViewModels)
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
            self?.updateFetchedData(totalCount: totalCount, viewModels)
            }, completionError: completion)
    }
    
    private func updateFetchedData(totalCount: Int, _ viewModels: [WalletCopytradingAccountTableViewCellViewModel]) {
        self.accounts = viewModels
        self.totalCount = totalCount
        self.skip += self.take
        self.canFetchMoreResults = true
        self.reloadDataProtocol?.didReloadData()
    }
    
    private func fetch(_ completionSuccess: @escaping (_ totalCount: Int, _ viewModels: [WalletCopytradingAccountTableViewCellViewModel]) -> Void, completionError: @escaping CompletionBlock) {
        
        SignalDataProvider.getAccounts(completion: { (copyTradingAccountsViewModel) in
            guard copyTradingAccountsViewModel != nil else {
                return ErrorHandler.handleApiError(error: nil, completion: completionError)
            }
            var viewModels = [WalletCopytradingAccountTableViewCellViewModel]()
            
            let totalCount = copyTradingAccountsViewModel?.accounts?.count ?? 0
            
            copyTradingAccountsViewModel?.accounts?.forEach({ (copyTradingAccountInfo) in
                let viewModel = WalletCopytradingAccountTableViewCellViewModel(copyTradingAccountInfo: copyTradingAccountInfo)
                viewModels.append(viewModel)
            })
            
            completionSuccess(totalCount, viewModels)
            completionError(.success)
        }, errorCompletion: completionError)
    }
}


// MARK: - Navigation
extension WalletCopytradingAccountListViewModel {
    func showDetail(at indexPath: IndexPath) {
    }
}

extension WalletCopytradingAccountListViewModel {
    func logoImageName() -> String {
        let imageName = "img_wallet_logo"
        return imageName
    }
    
    func noDataText() -> String {
        return "You don’t have any copytrading accounts yet"
    }
    
    func noDataImageName() -> String? {
        return nil
    }
    
    func noDataButtonTitle() -> String {
        let text = ""
        return text
    }
}


