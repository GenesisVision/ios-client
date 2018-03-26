//
//  ProgramDescriptionViewModel.swift
//  genesisvision-ios
//
//  Created by George on 23/03/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

final class ProgramDescriptionViewModel {
    // MARK: - Variables
    var title: String = "Program Info"
    
    var investmentProgramId: String?
    
    private var investmentProgramDetails: InvestmentProgramDetails?
    
    private var router: ProgramDescriptionRouter!
    
    // MARK: - Init
    init(withRouter router: ProgramDescriptionRouter, investmentProgramDetails: InvestmentProgramDetails?) {
        self.router = router
        self.investmentProgramDetails = investmentProgramDetails
    }
    
    // MARK: - Public methods
    func getProgramTitle() -> String {
        guard let title = investmentProgramDetails?.title else { return "" }
        
        return title
    }
    
    func getProgramDescription() -> String {
        guard let description = investmentProgramDetails?.description else { return "" }
        
        return description
    }
    
    func getProgramLogo() -> String {
        guard let logo = investmentProgramDetails?.logo else { return "" }
        
        return logo
    }
    
    func getProgramManagerUsername() -> String {
        guard let manager = investmentProgramDetails?.manager, let username = manager.username else { return "" }
        
        return "by " + username
    }
    
    func getProgramLevelText() -> String {
        guard let level = investmentProgramDetails?.level else { return 0.toString() }
        
        return level.toString()
    }
    
    // MARK: - Navigation
    func closeVC() {
        router.closeVC()
    }
}
