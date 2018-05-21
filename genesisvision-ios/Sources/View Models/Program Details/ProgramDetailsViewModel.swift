//
//  ProgramDetailsViewModel.swift
//  genesisvision-ios
//
//  Created by George on 15/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

protocol ProgramDetailsProtocol: class {
    func didFavoriteStateUpdated()
}

final class ProgramDetailsViewModel: TabmanViewModel {
    // MARK: - Variables
    var investmentProgramId: String!
    var investmentProgramDetails: InvestmentProgramDetails?
    
    weak var programDetailsProtocol: ProgramDetailsProtocol?
    
    var isFavorite: Bool {
        return investmentProgramDetails?.isFavorite ?? false
    }
    
    // MARK: - Init
    init(withRouter router: Router, investmentProgramId: String, tabmanViewModelDelegate: TabmanViewModelDelegate) {
        self.investmentProgramId = investmentProgramId
        
        super.init(withRouter: router, viewControllersCount: 1, defaultPage: 0, tabmanViewModelDelegate: tabmanViewModelDelegate)
        
        title = "Program Details"
        
        reloadData()
    }
    
    // MARK: - Public methods
    func didRequestCanceled(_ last: Bool) {
        guard !last else { return reloadData() }
        
        ProgramDataProvider.getProgram(investmentProgramId: investmentProgramId, completion: { [weak self] (viewModel) in
            guard let viewModel = viewModel else { return }
            self?.investmentProgramDetails = viewModel
            self?.reloadDetails()
        }) { (result) in }
    }
    
    func didInvested() {
        reloadData()
    }
    
    func didWithdrawn() {
        reloadData()
    }
    
    func reloadDetails() {
        if let vc = viewControllers.first as? ProgramDetailViewController, let investmentProgramDetails = investmentProgramDetails {
            vc.viewModel.updateDetails(with: investmentProgramDetails)
        }
    }
    
    func reloadData() {
        ProgramDataProvider.getProgram(investmentProgramId: investmentProgramId, completion: { [weak self] (viewModel) in
            guard let viewModel = viewModel else { return }
            self?.investmentProgramDetails = viewModel
            self?.programDetailsProtocol?.didFavoriteStateUpdated()
            self?.removeAllControllers()
            self?.setup()
        }) { (result) in }
    }
    
    private func setup() {
        if let router = router as? ProgramDetailsRouter, let investmentProgramDetails = investmentProgramDetails {
            if let vc = router.getDetail(with: investmentProgramDetails) {
                self.addController(vc)
                self.addItem(vc.viewModel.title)
            }
            
           if let vc = router.getDescription(with: investmentProgramDetails) {
                self.addController(vc)
                self.addItem(vc.viewModel.title)
            }
            
            if let tradesCount = investmentProgramDetails.tradesCount, tradesCount > 0, let vc = router.getTrades(with: investmentProgramId) {
                self.addController(vc)
                self.addItem(vc.viewModel.title)
            }
            
            if let isHistoryEnable = investmentProgramDetails.isHistoryEnable, isHistoryEnable, let vc = router.getHistory(with: investmentProgramId) {
                self.addController(vc)
                self.addItem(vc.viewModel.title)
            }
            
            if let hasNewRequests = investmentProgramDetails.hasNewRequests, hasNewRequests, let vc = router.getRequests(with: investmentProgramId) {
                self.addController(vc)
                self.addItem(vc.viewModel.title)
            }
            
            reloadPages()
        }
    }
    
    func changeFavorite(completion: @escaping CompletionBlock) {
        guard let investmentProgramId = investmentProgramId,
            let isFavorite = investmentProgramDetails?.isFavorite else { return }
        
        investmentProgramDetails?.isFavorite = !isFavorite
        ProgramDataProvider.programFavorites(isFavorite: isFavorite, investmentProgramId: investmentProgramId) { [weak self] (result) in
            switch result {
            case .success:
                break
            case .failure(let errorType):
                print(errorType)
                self?.investmentProgramDetails?.isFavorite = isFavorite
            }
            
            completion(result)
        }
    }
}
