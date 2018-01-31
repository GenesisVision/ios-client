//
//  ProgramDetailViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class ProgramDetailViewModel {
    
    private var router: ProgramDetailRouter!
    private var investmentProgramEntity: InvestmentProgramEntity!
    
    // MARK: - Init
    init(withRouter router: ProgramDetailRouter, withEntity entity: InvestmentProgramEntity) {
        self.router = router
        investmentProgramEntity = entity
    }
    
    func getNickname() -> String {
        return investmentProgramEntity.nickname
    }
    
    func getEntity() -> InvestmentProgramEntity {
        return investmentProgramEntity
    }
    
    // MARK: - Public methods
    // MARK: - Navigation
    func invest() {
        router.show(routeType: .invest)
    }
}
