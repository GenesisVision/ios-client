//
//  WalletViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class WalletViewModel {
    
    enum SectionType {
        case header
        case transactions
    }
    
    // MARK: - Variables
    var title: String = "Wallet"
    
    private var sections: [SectionType] = [.header, .transactions]

    private var router: WalletRouter!
    private var transactions = [WalletTransactionTableViewCellViewModel]()
    
    private var profileViewModel: ProfileShortViewModel? {
        didSet {
            balance = profileViewModel?.balance ?? 0.0
        }
    }
    
    private var balance: Double = 0.0
    private var currency: String = Constants.currency
    
    var dataType: DataType = .fake
    var skip = 0            //offset
    var totalCount = 0      //total count of programs
    
    /// Return view models for registration cell Nib files
    static var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [WalletHeaderTableViewCellViewModel.self,
                WalletTransactionTableViewCellViewModel.self]
    }
    
    /// Return view models for registration header/footer Nib files
    static var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] {
        return [DefaultTableHeaderView.self]
    }
    
    // MARK: - Init
    init(withRouter router: WalletRouter) {
        self.router = router
        
        setup()
    }
    
    // MARK: - Public methods
    // MARK: - Navigation
    func withdraw() {
        router.show(routeType: .withdraw)
    }
    
    // MARK: - Data methods
    func getBalance() -> Double {
        return balance
    }
    
    func fetchBalance(completion: @escaping CompletionBlock) {
        guard let token = AuthManager.authorizedToken else { return completion(.failure(reason: nil)) }
        
        isInvestorApp
            ? InvestorAPI.apiInvestorProfileGet(authorization: token) { [weak self] (viewModel, error) in
                guard error == nil else {
                    return ErrorHandler.handleApiError(error: error, completion: completion)
                }
                
                self?.profileViewModel = viewModel
                completion(.success)
            }
            : ManagerAPI.apiManagerProfileGet(authorization: token) { [weak self] (viewModel, error) in
                guard error == nil else {
                    return ErrorHandler.handleApiError(error: error, completion: completion)
                }
                
                self?.profileViewModel = viewModel
                completion(CompletionResult.success)
            }
    }
    
    private func fakeTransactions(completion: (_ transactionCellModels: [WalletTransactionTableViewCellViewModel]) -> Void) {
        var cellModels = [WalletTransactionTableViewCellViewModel]()
        
        for _ in 0..<Constants.TemplatesCounts.traders {
            cellModels.append(WalletTransactionTableViewCellViewModel(walletTransaction: WalletTransaction.templateModel))
        }
        
        completion(cellModels)
    }

    /// Fetch transactions from API -> Save fetched data -> Return CompletionBlock
    func fetchTransactions(completion: @escaping CompletionBlock) {
        switch dataType {
        case .api:
            fetchTransactions({ [weak self] (totalCount, viewModels) in
                self?.updateFetchedData(totalCount: totalCount, viewModels)
                }, completionError: completion)
        case .fake:
            fakeTransactions(completion: { [weak self] (viewModels) in
                self?.updateFetchedData(totalCount: viewModels.count, viewModels)
            })
        }
        
    }
    
    /// Fetch more transactions from API -> Save fetched data -> Return CompletionBlock
    func fetchMoreTransactions(completion: @escaping CompletionBlock) {
        if skip >= totalCount {
            return completion(.failure(reason: nil))
        }
        
        skip += Constants.Api.Take.transactions
        
        fetchTransactions({ [weak self] (totalCount, viewModels) in
            var allViewModels = self?.transactions ?? [WalletTransactionTableViewCellViewModel]()
            
            viewModels.forEach({ (viewModel) in
                allViewModels.append(viewModel)
            })
            
            self?.updateFetchedData(totalCount: totalCount, allViewModels)
            }, completionError: completion)
    }
    
    /// Fetch transactions from API -> Save fetched data -> Return CompletionBlock
    func refresh(completion: @escaping CompletionBlock) {
        skip = 0
        
        fetchTransactions({ [weak self] (totalCount, viewModels) in
            self?.updateFetchedData(totalCount: totalCount, viewModels)
            }, completionError: completion)
    }
    
    // MARK: - TableView
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        switch sections[section] {
        case .header:
            return 1
        case .transactions:
            return transactions.count
        }
    }
    
    func headerTitle(for section: Int) -> String? {
        switch sections[section] {
        case .transactions:
            return "Transactions"
        case .header:
            return nil
        }
    }
    
    func headerHeight(for section: Int) -> CGFloat {
        switch sections[section] {
        case .transactions:
            return 70.0
        case .header:
            return 1.0
        }
    }
    
    /// Get TableViewCellViewModel for IndexPath
    func model(at indexPath: IndexPath) -> CellViewAnyModel? {
        let type = sections[indexPath.section]
        switch type {
        case .header:
            return WalletHeaderTableViewCellViewModel(balance: balance, currency: currency)
        case .transactions:
            return transactions[indexPath.row]
        }
    }
    
    // MARK: - Private methods
    private func setup() {
        fetchBalance { (result) in
        }
    }
    
    /// Update saved transactions (WalletTransactionTableViewCellViewModel)
    private func updateFetchedData(totalCount: Int, _ viewModels: [WalletTransactionTableViewCellViewModel]) {
        self.transactions = viewModels
        self.totalCount = totalCount
    }
    
    /// Save [WalletTransaction] and total -> Return [WalletTransactionTableViewCellViewModel] or error
    private func fetchTransactions(_ completionSuccess: @escaping (_ totalCount: Int, _ viewModels: [WalletTransactionTableViewCellViewModel]) -> Void, completionError: @escaping CompletionBlock) {
        
        guard let authorization = AuthManager.authorizedToken else { return completionError(.failure(reason: nil)) }
        let filter = TransactionsFilter(skip: skip, take: Constants.Api.Take.transactions)
        
        fetchTransactions(authorization: authorization, filter: filter) { (walletTransactionsViewModel, error) in
            guard error == nil else {
                return ErrorHandler.handleApiError(error: error, completion: completionError)
            }
            var viewModels = [WalletTransactionTableViewCellViewModel]()
            
            let totalCount = walletTransactionsViewModel?.total ?? 0
            
            walletTransactionsViewModel?.transactions?.forEach({ (walletTransaction) in
                let viewModel = WalletTransactionTableViewCellViewModel(walletTransaction: walletTransaction)
                viewModels.append(viewModel)
            })
            
            completionSuccess(totalCount, viewModels)
            completionError(.success)
        }
    }
    
    /// Return WalletTransactionsViewModel from API
    private func fetchTransactions(authorization: String, filter: TransactionsFilter, completion: @escaping ((_ data: WalletTransactionsViewModel?,_ error: Error?) -> Void)) {
        
        isInvestorApp
            ? InvestorAPI.apiInvestorWalletTransactionsPost(authorization: authorization, filter: filter, completion: completion)
            : ManagerAPI.apiManagerWalletTransactionsPost(authorization: authorization, filter: filter, completion: completion)
    }
}
