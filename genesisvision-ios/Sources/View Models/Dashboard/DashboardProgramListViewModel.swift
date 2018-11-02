//
//  DashboardProgramListViewModel.swift
//  genesisvision-ios
//
//  Created by George on 21/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableView

final class DashboardProgramListViewModel {
    
    enum SectionType {
        case programList
    }
    
    // MARK: - Variables
    var activePrograms = true
    
    var title = "Programs"
    
    var sortingDelegateManager: SortingDelegateManager!
    var programListDelegateManager: DashboardProgramListDelegateManager!
    
    var highToLowValue: Bool = false
    
    private var sections: [SectionType] = [.programList]
    
    private var router: DashboardRouter!
    private var programsList: ProgramsList?
    
    weak var reloadDataProtocol: ReloadDataProtocol?
    
    var dateFrom: Date?
    var dateTo: Date?
    var chartPointsCount = 50
    
    var canFetchMoreResults = true
    var skip = 0
    var take = Constants.Api.take
    var totalCount = 0 {
        didSet {
            title = totalCount > 0 ? "Programs \(totalCount)" : "Programs"
        }
    }
    
    var bottomViewType: BottomViewType {
        return .dateRange
    }
    
    var viewModels = [CellViewAnyModel]() {
        didSet {
            guard let viewModels = viewModels as? [DashboardProgramTableViewCellViewModel] else { return }
            
            self.activeViewModels = viewModels.filter { $0.program.status != .archived }
            self.archiveViewModels = viewModels.filter { $0.program.status == .archived }
        }
    }
    var activeViewModels = [DashboardProgramTableViewCellViewModel]()
    var archiveViewModels = [DashboardProgramTableViewCellViewModel]()
    
    // MARK: - Init
    init(withRouter router: DashboardRouter) {
        self.router = router
        self.reloadDataProtocol = router.programListViewController
        
        programListDelegateManager = DashboardProgramListDelegateManager(with: self)
        sortingDelegateManager = SortingDelegateManager(.dashboardPrograms)
        
        NotificationCenter.default.addObserver(self, selector: #selector(programFavoriteStateChangeNotification(notification:)), name: .programFavoriteStateChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .programFavoriteStateChange, object: nil)
    }
    
    // MARK: - Public methods
    func changeFavorite(value: Bool, assetId: String, request: Bool = false, completion: @escaping CompletionBlock) {
        guard request else {
            guard let model = model(at: assetId) as? DashboardProgramTableViewCellViewModel else { return completion(.failure(errorType: .apiError(message: nil))) }
            model.program.personalDetails?.isFavorite = value
            completion(.success)
            return
        }
        
        ProgramsDataProvider.favorites(isFavorite: !value, assetId: assetId) { [weak self] (result) in
            switch result {
            case .success:
                guard let model = self?.model(at: assetId) as? DashboardProgramTableViewCellViewModel else { return completion(.failure(errorType: .apiError(message: nil))) }
                model.program.personalDetails?.isFavorite = value
                completion(.success)
            case .failure(let errorType):
                print(errorType)
                completion(result)
            }
        }
    }
    
    // MARK: - Private methods
    @objc private func programFavoriteStateChangeNotification(notification: Notification) {
        if let isFavorite = notification.userInfo?["isFavorite"] as? Bool, let assetId = notification.userInfo?["programId"] as? String {
            changeFavorite(value: isFavorite, assetId: assetId) { [weak self] (result) in
                self?.reloadDataProtocol?.didReloadData()
            }
        }
    }
    
    private func reinvest(_ value: Bool, programId: String) {
        if value {
            ProgramsDataProvider.reinvestOn(with: programId) { (result) in
                switch result {
                case .success:
                    break
                case .failure(let errorType):
                    ErrorHandler.handleError(with: errorType)
                }
            }
        } else {
            ProgramsDataProvider.reinvestOff(with: programId) { (result) in
                switch result {
                case .success:
                    break
                case .failure(let errorType):
                    ErrorHandler.handleError(with: errorType)
                }
            }
        }
    }
}

// MARK: - TableView
extension DashboardProgramListViewModel {
    // MARK: - Public methods
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [DashboardProgramTableViewCellViewModel.self]
    }
    
    func modelsCount() -> Int {
        return activePrograms ? activeViewModels.count : archiveViewModels.count
    }
    
    func numberOfSections() -> Int {
        return modelsCount() > 0 ? sections.count : 1
    }
    
    func numberOfRows(in section: Int) -> Int {
        return modelsCount()
    }
    
    func headerTitle(for section: Int) -> String? {
        return nil
    }
}

// MARK: - Navigation
extension DashboardProgramListViewModel {
    func logoImageName() -> String? {
        let imageName = "img_nodata_list"
        return imageName
    }
    
    func noDataText() -> String {
        return "you don’t have \nany programs yet.."
    }
    
    func noDataImageName() -> String? {
        return logoImageName()
    }
    
    func noDataButtonTitle() -> String {
        let text = "Browse assets"
        return text
    }
    
    func showDetail(at indexPath: IndexPath) {
        guard let model: DashboardProgramTableViewCellViewModel = model(at: indexPath) as? DashboardProgramTableViewCellViewModel else { return }
        
        let program = model.program
        guard let programId = program.id else { return }
        
        router.show(routeType: .showProgramDetails(programId: programId.uuidString))
    }
    
    func showProgramList() {
        router.show(routeType: .assetList)
    }
}

// MARK: - Fetch
extension DashboardProgramListViewModel {
    // MARK: - Public methods
    func fetch(completion: @escaping CompletionBlock) {
        fetch({ [weak self] (totalCount, viewModels) in
            self?.updateFetchedData(totalCount: totalCount, viewModels)
            }, completionError: completion)
    }
    
    /// Fetch more transactions from API -> Save fetched data -> Return CompletionBlock
    func fetchMore(at row: Int) -> Bool {
        if modelsCount() - Constants.Api.fetchThreshold == row && canFetchMoreResults {
            fetchMore()
        }
        
        return skip < totalCount
    }
    
    func fetchMore() {
        guard skip < totalCount else { return }
        
        canFetchMoreResults = false
        fetch({ [weak self] (totalCount, viewModels) in
            var allViewModels = self?.viewModels ?? [DashboardProgramTableViewCellViewModel]()
            
            viewModels.forEach({ (viewModel) in
                allViewModels.append(viewModel)
            })
            
            self?.updateFetchedData(totalCount: totalCount, allViewModels as! [DashboardProgramTableViewCellViewModel])
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
    
    /// Get TableViewCellViewModel for IndexPath
    func model(at indexPath: IndexPath) -> CellViewAnyModel? {
        guard programsList != nil else {
            return nil
        }
        
        return activePrograms ? activeViewModels[indexPath.row] : archiveViewModels[indexPath.row]
    }
    
    func model(at assetId: String) -> CellViewAnyModel? {
        if activePrograms {
            if let i = activeViewModels.index(where: { $0.program.id?.uuidString == assetId }) {
                return activeViewModels[i]
            }
        } else {
            if let i = archiveViewModels.index(where: { $0.program.id?.uuidString == assetId }) {
                return archiveViewModels[i]
            }
        }
        
        return nil
    }
    
    func getDetailsViewController(with indexPath: IndexPath) -> ProgramViewController? {
        guard let model = model(at: indexPath) as? DashboardProgramTableViewCellViewModel else {
            return nil
        }
        
        let program = model.program
        guard let programId = program.id else { return nil}
        
        return router.getDetailsViewController(with: programId.uuidString)
    }
    
    // MARK: - Private methods
    private func updateFetchedData(totalCount: Int, _ viewModels: [DashboardProgramTableViewCellViewModel]) {
        self.viewModels = viewModels
        self.totalCount = totalCount
        self.skip += self.take
        self.canFetchMoreResults = true
        self.reloadDataProtocol?.didReloadData()
    }
    
    private func fetch(_ completionSuccess: @escaping (_ totalCount: Int, _ viewModels: [DashboardProgramTableViewCellViewModel]) -> Void, completionError: @escaping CompletionBlock) {
        
        let sorting = sortingDelegateManager.sortingManager?.getSelectedSorting()
        DashboardDataProvider.getProgramList(with: sorting as? InvestorAPI.Sorting_v10InvestorProgramsGet, from: dateFrom, to: dateTo, chartPointsCount: chartPointsCount, skip: skip, take: take, completion: { [weak self] (programsList) in
            guard let programsList = programsList else { return completionError(.failure(errorType: .apiError(message: nil))) }
            
            self?.programsList = programsList
            
            var viewModels = [DashboardProgramTableViewCellViewModel]()
            
            let totalCount = programsList.programs?.count ?? 0
            
            programsList.programs?.forEach({ (program) in
                let dashboardTableViewCellModel = DashboardProgramTableViewCellViewModel(program: program, reloadDataProtocol: self?.router.programListViewController, delegate:
                    self?.router.programListViewController, reinvestProtocol: self)
                viewModels.append(dashboardTableViewCellModel)
            })
            
            completionSuccess(totalCount, viewModels)
            completionError(.success)
            }, errorCompletion: completionError)
    }
}

extension DashboardProgramListViewModel: ReinvestProtocol {
    func didChangeReinvestSwitch(value: Bool, assetId: String) {
        reinvest(value, programId: assetId)
    }
}
