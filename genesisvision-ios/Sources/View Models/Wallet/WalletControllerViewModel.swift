//
//  WalletControllerViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

final class WalletControllerViewModel {
    
    enum SectionType {
        case header
        case transactions
    }
    
    // MARK: - Variables
    var title: String = "Wallet"
    
    private var sections: [SectionType] = [.header, .transactions]

    private var router: WalletRouter!
    private var transactions = [WalletTransactionTableViewCellViewModel]()
    private weak var delegate: WalletHeaderTableViewCellProtocol?
    private weak var reloadDataProtocol: ReloadDataProtocol?
    
    private var balance: Double = 0.0 {
        didSet {
            self.usdBalance = balance * self.rate
        }
    }
    private var currency: String = Constants.currency
    private var rate: Double = 0.0
    private var usdBalance: Double = 0.0
    
    var dataType: DataType = .api
    var skip = 0            //offset
    var take = Constants.Api.take
    var totalCount = 0      //total count of programs
    
    var filter: TransactionsFilter?
    
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
        self.delegate = router.currentController() as? WalletHeaderTableViewCellProtocol
        self.reloadDataProtocol = router.currentController() as? ReloadDataProtocol
        
        setup()
    }
    
    // MARK: - Data methods
    func getBalance() -> Double {
        return balance
    }
}

// MARK: - TableView
extension WalletControllerViewModel {
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
            return 50.0
        case .header:
            return 0.0
        }
    }
    
    /// Get TableViewCellViewModel for IndexPath
    func model(at indexPath: IndexPath) -> CellViewAnyModel? {
        let type = sections[indexPath.section]
        switch type {
        case .header:
            return WalletHeaderTableViewCellViewModel(balance: balance, currency: currency, usdBalance: usdBalance, delegate: delegate)
        case .transactions:
            return transactions[indexPath.row]
        }
    }
    
    func getDetailViewController(with indexPath: IndexPath) -> ProgramDetailViewController? {
        guard let model: WalletTransactionTableViewCellViewModel = model(at: indexPath) as? WalletTransactionTableViewCellViewModel,
            let investmentProgram = model.walletTransaction.investmentProgram,
            let investmentProgramId = investmentProgram.id
            else { return nil }
        
        return router.getDetailViewController(with: investmentProgramId.uuidString)
    }

    // MARK: - Private methods
    private func setup() {
        filter = TransactionsFilter(investmentProgramId: nil, type: .all, skip: skip, take: take)
        fetchBalance { (result) in }
    }
}

// MARK: - Fetch
extension WalletControllerViewModel {
    func fetchBalance(completion: @escaping CompletionBlock) {
        AuthManager.getSavedRate { [weak self] (value) in
            self?.rate = value
            
            AuthManager.getBalance { [weak self] (value) in
                self?.balance = value
                completion(.success)
            }
        }
    }
    
    /// Fetch transactions from API -> Save fetched data -> Return CompletionBlock
    func fetchTransactions(completion: @escaping CompletionBlock) {
        switch dataType {
        case .api:
            fetchTransactions({ [weak self] (totalCount, viewModels) in
                self?.updateFetchedData(totalCount: totalCount, viewModels)
                completion(.success)
                }, completionError: completion)
        case .fake:
            break
        }
        
    }
    
    /// Fetch more transactions from API -> Save fetched data -> Return CompletionBlock
    func fetchMoreTransactions(completion: @escaping CompletionBlock) {
        if skip >= totalCount {
            return completion(.failure(reason: nil))
        }
        
        skip += Constants.Api.take
        
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
    
    /// Update saved transactions (WalletTransactionTableViewCellViewModel)
    private func updateFetchedData(totalCount: Int, _ viewModels: [WalletTransactionTableViewCellViewModel]) {
        self.transactions = viewModels
        self.totalCount = totalCount
        self.reloadDataProtocol?.didReloadData()
    }
    
    /// Save [WalletTransaction] and total -> Return [WalletTransactionTableViewCellViewModel] or error
    private func fetchTransactions(_ completionSuccess: @escaping (_ totalCount: Int, _ viewModels: [WalletTransactionTableViewCellViewModel]) -> Void, completionError: @escaping CompletionBlock) {
        guard let filter = filter else { return completionError(.failure(reason: nil)) }
        
        WalletDataProvider.getWalletTransactions(with: filter) { (transactionsViewModel) in
            guard transactionsViewModel != nil else {
                return ErrorHandler.handleApiError(error: nil, completion: completionError)
            }
            var viewModels = [WalletTransactionTableViewCellViewModel]()
            
            let totalCount = transactionsViewModel?.total ?? 0
            
            transactionsViewModel?.transactions?.forEach({ (walletTransaction) in
                let viewModel = WalletTransactionTableViewCellViewModel(walletTransaction: walletTransaction)
                viewModels.append(viewModel)
            })
            
            completionSuccess(totalCount, viewModels)
            completionError(.success)
        }
    }
}


// MARK: - Navigation
extension WalletControllerViewModel {
    func withdraw() {
        router.show(routeType: .withdraw)
    }
    
    func deposit() {
        router.show(routeType: .deposit)
    }
    
    func filters() {
        router.show(routeType: .showFilterVC(walletControllerViewModel: self))
    }
    
    func showDetail(at indexPath: IndexPath) {
        guard let model: WalletTransactionTableViewCellViewModel = model(at: indexPath) as? WalletTransactionTableViewCellViewModel,
            let investmentProgram = model.walletTransaction.investmentProgram,
            let investmentProgramId = investmentProgram.id
            else { return }
        
        router.show(routeType: .showProgramDetail(investmentProgramId: investmentProgramId.uuidString))
    }
}
