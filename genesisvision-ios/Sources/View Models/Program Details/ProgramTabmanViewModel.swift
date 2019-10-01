//
//  ProgramTabmanViewModel.swift
//  genesisvision-ios
//
//  Created by George on 15/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIColor
import Tabman

final class ProgramTabmanViewModel: TabmanViewModel {
    // MARK: - Variables
    var programId: String!
    
    var programDetailsFull: ProgramDetailsFull?

    var сurrency: ProgramsAPI.CurrencySecondary_v10ProgramsByIdGet?
    weak var favoriteStateUpdatedProtocol: FavoriteStateUpdatedProtocol?
    
    var isFavorite: Bool {
        return programDetailsFull?.personalProgramDetails?.isFavorite ?? false
    }
    
    // MARK: - Init
    init(withRouter router: Router, programId: String) {
        self.programId = programId
        
        super.init(withRouter: router, viewControllersCount: 1, defaultPage: 0)
        
        сurrency = ProgramsAPI.CurrencySecondary_v10ProgramsByIdGet(rawValue: getSelectedCurrency())
        title = "Program Details"
        backgroundColor = UIColor.Cell.bg
    }
    
    // MARK: - Public methods
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
    
    func setup(_ viewModel: ProgramDetailsFull? = nil) {
        removeAllControllers()
        
        if let viewModel = viewModel {
            self.programDetailsFull = viewModel
        }
        
        self.items = []
        
        if let router = router as? ProgramTabmanRouter, let programDetailsFull = programDetailsFull {
            if let vc = router.getInfo(with: programDetailsFull) {
                self.items?.append(TMBarItem(title: vc.viewModel.title.uppercased()))
                self.addController(vc)
            }
            
            if let vc = router.getProfit(with: programId) {
                self.items?.append(TMBarItem(title: vc.viewModel.title.uppercased()))
                self.addController(vc)
            }
            
            if let vc = router.getBalance(with: programId) {
                self.items?.append(TMBarItem(title: vc.viewModel.title.uppercased()))
                self.addController(vc)
            }
            
            if let tradesCount = programDetailsFull.statistic?.tradesCount, tradesCount > 0, let currency = programDetailsFull.currency?.rawValue, let currencyType = CurrencyType(rawValue: currency), let tradesVC = router.getTrades(with: programId, currencyType: currencyType), let openTradesVC = router.getTradesOpen(with: programId, currencyType: currencyType) {
                self.items?.append(TMBarItem(title: openTradesVC.viewModel.title.uppercased()))
                self.addController(openTradesVC)
                
                self.items?.append(TMBarItem(title: tradesVC.viewModel.title.uppercased()))
                self.addController(tradesVC)
            }
            
            if let currency = programDetailsFull.currency?.rawValue, let currencyType = CurrencyType(rawValue: currency), let vc = router.getPeriodHistory(with: programId, currency: currencyType) {
                self.items?.append(TMBarItem(title: vc.viewModel.title.uppercased()))
                self.addController(vc)
            }
            
            if let _ = programDetailsFull.personalProgramDetails, let vc = router.getEvents(with: programId) {
                self.items?.append(TMBarItem(title: vc.viewModel.title.uppercased()))
                self.addController(vc)
            }
            
            reloadPages()
        }
    }
}
