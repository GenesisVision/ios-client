//
//  ProgramDetailViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class ProgramDetailViewModel {
    // MARK: - Variables
    var router: ProgramDetailRouter
    private var investmentProgramEntity: InvestmentProgramEntity!
    
    // MARK: - Init
    init(withRouter router: ProgramDetailRouter, with investmentProgramEntity: InvestmentProgramEntity) {
        self.router = router
        self.investmentProgramEntity = investmentProgramEntity
    }
    
    func getNickname() -> String {
        return investmentProgramEntity.nickname
    }
    
    func getModel() -> InvestmentProgramEntity {
        return investmentProgramEntity
    }
    
    // MARK: - Public methods
    // MARK: - Navigation
    func invest() {
        router.show(routeType: .invest)
    }
}
