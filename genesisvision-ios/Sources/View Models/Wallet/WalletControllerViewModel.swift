//
//  WalletControllerViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableViewHeaderFooterView

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
    
    var canFetchMoreResults = true
    var dataType: DataType = .api
    var skip = 0            //offset
    var take = Constants.Api.take
    var totalCount = 0      //total count of programs
    
    var filter: TransactionsFilter?
    
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
    /// Return view models for registration cell Nib files
    static var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [WalletHeaderTableViewCellViewModel.self,
                WalletTransactionTableViewCellViewModel.self]
    }
    
    /// Return view models for registration header/footer Nib files
    static var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] {
        return [SortHeaderView.self]
    }
    
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
            guard let sort = filter?.type?.rawValue else { return ""}
            return sort + " Transactions"
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
            return WalletHeaderTableViewCellViewModel(balance: balance, usdBalance: usdBalance, imageName: logoImageName(), delegate: delegate)
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
        filter = TransactionsFilter(investmentProgramId: nil, type: Constants.Filters.walletModelTypeDefault, skip: skip, take: take)
        fetchBalance { (result) in }
    }
}

// MARK: - Fetch
extension WalletControllerViewModel {
    func fetchBalance(completion: @escaping CompletionBlock) {
        AuthManager.getSavedRate { [weak self] (value) in
            self?.rate = value
            
            AuthManager.getBalance(completion: { [weak self] (value) in
                self?.balance = value
                completion(.success)
            }, completionError: completion)
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
    func fetchMoreTransactions(at row: Int) -> Bool {
        if numberOfRows(in: 1) - Constants.Api.fetchThreshold == row && canFetchMoreResults {
            fetchMoreTransactions()
        }
        
        return skip < totalCount
    }
    
    func fetchMoreTransactions() {
        guard skip < totalCount else { return }
        
        canFetchMoreResults = false
        fetchTransactions({ [weak self] (totalCount, viewModels) in
            var allViewModels = self?.transactions ?? [WalletTransactionTableViewCellViewModel]()
            
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
        self.skip += self.take
        self.canFetchMoreResults = true
        self.reloadDataProtocol?.didReloadData()
    }
    
    /// Save [WalletTransaction] and total -> Return [WalletTransactionTableViewCellViewModel] or error
    private func fetchTransactions(_ completionSuccess: @escaping (_ totalCount: Int, _ viewModels: [WalletTransactionTableViewCellViewModel]) -> Void, completionError: @escaping CompletionBlock) {
        guard let filter = filter else { return completionError(.failure(errorType: .apiError(message: nil))) }
        
        WalletDataProvider.getWalletTransactions(with: filter, completion: { (transactionsViewModel) in
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
        }, errorCompletion: completionError)
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
    
    func showProgramList() {
        router.show(routeType: .programList)
    }
}

extension WalletControllerViewModel {
    func logoImageName() -> String {
        let imageName = "img_wallet_logo"
        return imageName
    }
    
    func noDataText() -> String {
        return "you don’t have \nany transactions"
    }
    
    func noDataImageName() -> String? {
        return nil
    }
    
    func noDataButtonTitle() -> String {
        let text = "Browse programs"
        return text.uppercased()
    }
}
