//
//  ProgramDetailsViewModel.swift
//  genesisvision-ios
//
//  Created by George on 15/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIColor

protocol ProgramDetailsProtocol: class {
    func didFavoriteStateUpdated()
}

final class ProgramDetailsViewModel: TabmanViewModel {
    // MARK: - Variables
    var programId: String!
    var programDetailsFull: ProgramDetailsFull?
    var сurrency: ProgramsAPI.CurrencySecondary_v10ProgramsByIdGet?
    weak var programDetailsProtocol: ProgramDetailsProtocol?
    
    var isFavorite: Bool {
        return programDetailsFull?.personalProgramDetails?.isFavorite ?? false
    }
    
    // MARK: - Init
    init(withRouter router: Router, programId: String, tabmanViewModelDelegate: TabmanViewModelDelegate) {
        self.programId = programId
        
        super.init(withRouter: router, viewControllersCount: 1, defaultPage: 0, tabmanViewModelDelegate: tabmanViewModelDelegate)
        
        сurrency = ProgramsAPI.CurrencySecondary_v10ProgramsByIdGet(rawValue: getSelectedCurrency())
        title = "Program Details"
        backgroundColor = UIColor.Cell.bg
    }
    
    // MARK: - Public methods
    func didRequestCanceled(_ last: Bool) {
        setup()
    }
    
    func didInvested() {
        setup()
    }
    
    func didWithdrawn() {
        setup()
    }
    
    func reloadDetails() {
        if let vc = viewControllers.first as? ProgramInfoViewController, let programDetailsFull = programDetailsFull {
            vc.viewModel.updateDetails(with: programDetailsFull)
        }
    }
    
    func updateDetails(_ programDetailsFull: ProgramDetailsFull) {
        if let vc = viewControllers.first as? ProgramInfoViewController {
            vc.viewModel.updateDetails(with: programDetailsFull)
        }
    }
    
    func changeFavorite(completion: @escaping CompletionBlock) {
        guard let programId = programId,
            let isFavorite = programDetailsFull?.personalProgramDetails?.isFavorite else { return }
        
        programDetailsFull?.personalProgramDetails?.isFavorite = !isFavorite
        ProgramsDataProvider.programFavorites(isFavorite: isFavorite, programId: programId) { [weak self] (result) in
            switch result {
            case .success:
                break
            case .failure(let errorType):
                print(errorType)
                self?.programDetailsFull?.personalProgramDetails?.isFavorite = isFavorite
            }
            
            completion(result)
        }
    }
    
    func setup(_ viewModel: ProgramDetailsFull? = nil) {
        removeAllControllers()
        
        if let viewModel = viewModel {
            self.programDetailsFull = viewModel
        }
        
        if let router = router as? ProgramDetailsRouter, let programDetailsFull = programDetailsFull {
            if let vc = router.getInfo(with: programDetailsFull) {
                self.addController(vc)
                self.addItem(vc.viewModel.title)
            }
            
            if let tradesCount = programDetailsFull.statistic?.tradesCount, tradesCount > 0, let vc = router.getTrades(with: programId) {
                self.addController(vc)
                self.addItem(vc.viewModel.title)
            }
            
            if let isInvested = programDetailsFull.personalProgramDetails?.isInvested, isInvested, let vc = router.getHistory(with: programId) {
                self.addController(vc)
                self.addItem(vc.viewModel.title)
            }
            
            if let vc = router.getBalance(with: programId) {
                self.addController(vc)
                self.addItem(vc.viewModel.title)
            }
            
            if let vc = router.getProfit(with: programId) {
                self.addController(vc)
                self.addItem(vc.viewModel.title)
            }
            
            reloadPages()
        }
    }
}
