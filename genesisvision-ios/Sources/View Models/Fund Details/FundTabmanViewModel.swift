//
//  FundTabmanViewModel.swift
//  genesisvision-ios
//
//  Created by George on 25/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIColor
import Tabman

final class FundTabmanViewModel: TabmanViewModel {
    // MARK: - Variables
    var fundId: String!
    
    var fundDetailsFull: FundDetailsFull?

    var сurrency: FundsAPI.Currency_v10FundsByIdGet?
    weak var favoriteStateUpdatedProtocol: FavoriteStateUpdatedProtocol?
    
    var isFavorite: Bool {
        return fundDetailsFull?.personalFundDetails?.isFavorite ?? false
    }
    
    // MARK: - Init
    init(withRouter router: Router, fundId: String) {
        self.fundId = fundId
        
        super.init(withRouter: router, viewControllersCount: 1, defaultPage: 0)
        
        сurrency = FundsAPI.Currency_v10FundsByIdGet(rawValue: getSelectedCurrency())
        title = "Fund Details"
        backgroundColor = UIColor.Cell.bg
    }
    
    // MARK: - Public methods
    func reloadDetails() {
        if let vc = viewControllers.first as? FundInfoViewController, let fundDetailsFull = fundDetailsFull {
            vc.viewModel.updateDetails(with: fundDetailsFull)
        }
    }
    
    func updateDetails(_ fundDetailsFull: FundDetailsFull) {
        if let vc = viewControllers.first as? FundInfoViewController {
            vc.viewModel.updateDetails(with: fundDetailsFull)
        }
    }
    
    func setup(_ viewModel: FundDetailsFull? = nil) {
        removeAllControllers()
        
        if let viewModel = viewModel {
            self.fundDetailsFull = viewModel
        }
        
        self.items = []
        
        if let router = router as? FundTabmanRouter, let fundDetailsFull = fundDetailsFull {
            if let vc = router.getInfo(with: fundDetailsFull) {
                self.addController(vc)
                self.items?.append(TMBarItem(title: vc.viewModel.title.uppercased()))
            }
            
            if let vc = router.getAssets(with: fundId) {
                self.addController(vc)
                self.items?.append(TMBarItem(title: vc.viewModel.title.uppercased()))
            }
            
            if let vc = router.getReallocateHistory(with: fundId) {
                self.addController(vc)
                self.items?.append(TMBarItem(title: vc.viewModel.title.uppercased()))
            }
            
            if let vc = router.getProfit(with: fundId) {
                self.addController(vc)
                self.items?.append(TMBarItem(title: vc.viewModel.title.uppercased()))
            }
            
            if let vc = router.getBalance(with: fundId) {
                self.addController(vc)
                self.items?.append(TMBarItem(title: vc.viewModel.title.uppercased()))
            }
            
            if let vc = router.getEvents(with: fundId) {
                self.addController(vc)
                self.items?.append(TMBarItem(title: vc.viewModel.title.uppercased()))
            }
            
            reloadPages()
        }
    }
}
