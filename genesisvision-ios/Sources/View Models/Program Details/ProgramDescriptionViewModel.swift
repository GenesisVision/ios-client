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
    var title: String = "Strategy".uppercased()
    
    var programId: String?
    
    private var programDetailsFull: ProgramDetailsFull?
    
    private var router: ProgramDescriptionRouter!
    
    // MARK: - Init
    init(withRouter router: ProgramDescriptionRouter, programDetailsFull: ProgramDetailsFull?) {
        self.router = router
        self.programDetailsFull = programDetailsFull
    }
    
    // MARK: - Public methods
    func getProgramTitle() -> String {
        guard let title = programDetailsFull?.title else { return "" }
        
        return title
    }
    
    func getProgramDescription() -> String {
        guard let description = programDetailsFull?.description else { return "" }
        
        return description
    }
    
    func getProgramLogo() -> String {
        guard let logo = programDetailsFull?.logo else { return "" }
        
        return logo
    }
    
    func getProgramManagerUsername() -> String {
        guard let manager = programDetailsFull?.manager, let username = manager.username else { return "" }
        
        return "by " + username
    }
    
    func getProgramLevelText() -> String {
        guard let level = programDetailsFull?.level else { return 0.toString() }
        
        return level.toString()
    }
    
    // MARK: - Navigation
    func closeVC() {
        router.closeVC()
    }
}
