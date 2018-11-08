//
//  WalletControllerViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableViewHeaderFooterView

struct TransactionsFilter {
    public enum ModelType: String, Codable {
        case all = "All"
        case _internal = "Internal"
        case external = "External"
    }

    public var programId: UUID?
    public var type: ModelType?
    public var skip: Int?
    public var take: Int?
}

final class WalletControllerViewModel {
    
    enum SectionType {
        case header
        case transactions
    }
    
    // MARK: - Variables
    var title: String = "Wallet"
    
    var wallet: WalletSummary?
    
    private var sections: [SectionType] = [.header, .transactions]

    private var router: WalletRouter!
    private var transactions = [WalletTransactionTableViewCellViewModel]()
    private weak var reloadDataProtocol: ReloadDataProtocol?

    var canFetchMoreResults = true
    var dataType: DataType = .api
    var skip = 0            //offset
    var take = Api.take
    var totalCount = 0      //total count of programs
    
    var filter: TransactionsFilter?
    
    // MARK: - Init
    init(withRouter router: WalletRouter) {
        self.router = router
        self.reloadDataProtocol = router.topViewController() as? ReloadDataProtocol
        
        setup()
    }
}

// MARK: - TableView
extension WalletControllerViewModel {
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [WalletTransactionTableViewCellViewModel.self]
    }
    
    /// Return view models for registration header/footer Nib files
    var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] {
        return [WalletTableHeaderView.self, DefaultTableHeaderView.self]
    }
    
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        switch sections[section] {
        case .header:
            return 0
        case .transactions:
            return transactions.count
        }
    }
    func sortTitle() -> String? {
        guard let sort = filter?.type?.rawValue else { return ""}
        return sort + " Transactions"
    }
    
    func headerTitle(for section: Int) -> String? {
        switch sections[section] {
        case .transactions:
            return "Transaction history"
        case .header:
            return nil
        }
    }
    
    func headerHeight(for section: Int) -> CGFloat {
        switch sections[section] {
        case .header:
            return 250.0
        case .transactions:
            return 86.0
        }
    }
    
    /// Get TableViewCellViewModel for IndexPath
    func model(at indexPath: IndexPath) -> CellViewAnyModel? {
        let type = sections[indexPath.section]
        switch type {
        case .header:
            return nil
        case .transactions:
            return transactions[indexPath.row]
        }
    }
    
    func getDetailsViewController(with indexPath: IndexPath) -> ProgramViewController? {
//        guard let model: WalletTransactionTableViewCellViewModel = model(at: indexPath) as? WalletTransactionTableViewCellViewModel,
//            let program = model.walletTransaction.program,
//            let programId = program.id
//            else { return nil }
        let uuidString = "" //programId.uuidString
        return router.getDetailsViewController(with: uuidString)
    }

    // MARK: - Private methods
    private func setup() {
        //TODO: type: nil
        filter = TransactionsFilter(programId: nil, type: nil, skip: skip, take: take)
        fetchBalance { (result) in }
    }
}

// MARK: - Fetch
extension WalletControllerViewModel {
    func fetchBalance(completion: @escaping CompletionBlock) {
        guard let currency = WalletAPI.Currency_v10WalletByCurrencyGet(rawValue: getSelectedCurrency()) else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        WalletDataProvider.getWallet(with: currency, completion: { [weak self] (viewModel) in
            guard let viewModel = viewModel else {
                return completion(.failure(errorType: .apiError(message: nil)))
            }
            
            self?.wallet = viewModel
            
            completion(.success)
        }, errorCompletion: completion)
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
        if numberOfRows(in: 1) - Api.fetchThreshold == row && canFetchMoreResults && transactions.count >= take {
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
        
        WalletDataProvider.getWalletTransactions(with: nil, from: nil, to: nil, assetType: nil, txAction: nil, skip: skip, take: take, completion: { (transactionsViewModel) in
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
//        guard let model: WalletTransactionTableViewCellViewModel = model(at: indexPath) as? WalletTransactionTableViewCellViewModel,
//            let program = model.walletTransaction.program,
//            let programId = program.id
//            else { return }
//        
//        router.show(routeType: .showProgramDetails(programId: programId.uuidString))
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
        let text = ""
        return text
    }
}
