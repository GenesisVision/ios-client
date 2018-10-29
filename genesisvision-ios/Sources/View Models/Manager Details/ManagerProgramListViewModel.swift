//
//  ManagerProgramListViewModel.swift
//  genesisvision-ios
//
//  Created by George on 18/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableView

final class ManagerProgramListViewModel {
    
    enum SectionType {
        case programList
    }
    
    // MARK: - Variables
    var activePrograms = true
    
    var managerId: String!
    var managerProfileDetails: ManagerProfileDetails?
    
    var title = "Programs"
    
    var sortingDelegateManager: SortingDelegateManager!
    var programListDelegateManager: ManagerProgramListDelegateManager!
    
    var highToLowValue: Bool = false
    
    private var sections: [SectionType] = [.programList]
    
    private var router: ManagerProgramListRouter!
    private var programsList: ProgramsList?
    
    weak var reloadDataProtocol: ReloadDataProtocol?
    
    var dateFrom: Date?
    var dateTo: Date?
    
    var canFetchMoreResults = true
    var skip = 0
    var take = Constants.Api.take
    var totalCount = 0 {
        didSet {
            title = totalCount > 0 ? "Programs \(totalCount)" : "Programs"
        }
    }
    
    var bottomViewType: BottomViewType {
        return .sort
    }
    
    var viewModels = [ProgramTableViewCellViewModel]()
    
    // MARK: - Init
    init(withRouter router: ManagerProgramListRouter, managerId: String) {
        self.router = router
        self.managerId = managerId
        self.reloadDataProtocol = router.managerProgramsViewController
        
        sortingDelegateManager = SortingDelegateManager(.programs)
        programListDelegateManager = ManagerProgramListDelegateManager(with: self)
    }
    // MARK: - Public methods
    func changeFavorite(value: Bool, assetId: String, request: Bool = false, completion: @escaping CompletionBlock) {
        guard request else {
            guard let model = model(at: assetId) as? ProgramTableViewCellViewModel else { return completion(.failure(errorType: .apiError(message: nil))) }
            model.program.personalDetails?.isFavorite = value
            completion(.success)
            return
        }
        
        ProgramsDataProvider.favorites(isFavorite: !value, assetId: assetId) { [weak self] (result) in
            switch result {
            case .success:
                guard let model = self?.model(at: assetId) as? ProgramTableViewCellViewModel else { return completion(.failure(errorType: .apiError(message: nil))) }
                model.program.personalDetails?.isFavorite = value
                completion(.success)
            case .failure(let errorType):
                print(errorType)
                completion(result)
            }
        }
    }
    
    func hideHeader(value: Bool = true) {
        if let parentRouter = router.parentRouter, let managerRouter = parentRouter.parentRouter as? ManagerRouter {
            managerRouter.managerViewController.hideHeader(value)
        }
    }
}

// MARK: - TableView
extension ManagerProgramListViewModel {
    // MARK: - Public methods
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [ProgramTableViewCellViewModel.self]
    }
    
    func modelsCount() -> Int {
        return viewModels.count
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
extension ManagerProgramListViewModel {
    func logoImageName() -> String? {
        let imageName = "img_nodata_list"
        return imageName
    }
    
    func noDataText() -> String {
        return "manager don’t have \nany programs yet.."
    }
    
    func noDataImageName() -> String? {
        return logoImageName()
    }
    
    func noDataButtonTitle() -> String {
        return "Update"
    }
    
    func showDetail(at indexPath: IndexPath) {
        guard let model: ProgramTableViewCellViewModel = model(at: indexPath) as? ProgramTableViewCellViewModel else { return }
        
        let program = model.program
        guard let programId = program.id else { return }
        
        router.show(routeType: .showProgramDetails(programId: programId.uuidString))
    }
}

// MARK: - Fetch
extension ManagerProgramListViewModel {
    // MARK: - Public methods
    func fetch(completion: @escaping CompletionBlock) {
        fetch({ [weak self] (totalCount, viewModels) in
            self?.updateFetchedData(totalCount: totalCount, viewModels)
            }, completionError: completion)
    }
    
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
            var allViewModels = self?.viewModels ?? [ProgramTableViewCellViewModel]()
            
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
    
    /// Get TableViewCellViewModel for IndexPath
    func model(at indexPath: IndexPath) -> CellViewAnyModel? {
        guard programsList != nil else {
            return nil
        }
        
        return viewModels[indexPath.row]
    }
    
    func model(at programId: String) -> CellViewAnyModel? {
        if let i = viewModels.index(where: { $0.program.id?.uuidString == programId }) {
            return viewModels[i]
        }
        
        return nil
    }
    
    func getDetailsViewController(with indexPath: IndexPath) -> ProgramViewController? {
        guard let model = model(at: indexPath) as? ProgramTableViewCellViewModel else {
            return nil
        }
        
        let program = model.program
        guard let programId = program.id else { return nil}
        
        return router.getDetailsViewController(with: programId.uuidString)
    }
    
    // MARK: - Private methods
    private func updateFetchedData(totalCount: Int, _ viewModels: [ProgramTableViewCellViewModel]) {
        self.viewModels = viewModels
        self.totalCount = totalCount
        self.skip += self.take
        self.canFetchMoreResults = true
        self.reloadDataProtocol?.didReloadData()
    }
    
    private func fetch(_ completionSuccess: @escaping (_ totalCount: Int, _ viewModels: [ProgramTableViewCellViewModel]) -> Void, completionError: @escaping CompletionBlock) {
    
        ProgramsDataProvider.get(managerId: managerId, skip: skip, take: take, completion: { [weak self] (programsList) in
            guard let programsList = programsList else { return completionError(.failure(errorType: .apiError(message: nil))) }
            
            self?.programsList = programsList
            
            var viewModels = [ProgramTableViewCellViewModel]()
            
            let totalCount = programsList.total ?? 0
            
            programsList.programs?.forEach({ (program) in
                let programTableViewCellViewModel = ProgramTableViewCellViewModel(program: program, delegate: nil)
                viewModels.append(programTableViewCellViewModel)
            })
            
            completionSuccess(totalCount, viewModels)
            completionError(.success)
            }, errorCompletion: completionError)
    }
}

final class ManagerProgramListDelegateManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var viewModel: ManagerProgramListViewModel?
    weak var delegate: DelegateManagerProtocol?

    init(with viewModel: ManagerProgramListViewModel) {
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
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows(in: section) ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections() ?? 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.delegateManagerScrollViewDidScroll(scrollView)
        scrollView.isScrollEnabled = scrollView.contentOffset.y > -40.0
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.delegateManagerScrollViewWillBeginDragging(scrollView)
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if translation.y > 0 {
            //            print("down")
            scrollView.isScrollEnabled = scrollView.contentOffset.y > -40.0
        } else {
            //            print("up")
            scrollView.isScrollEnabled = scrollView.contentOffset.y >= -40.0
        }
    }
}
