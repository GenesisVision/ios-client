//
//  ProgramDetailViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class ProgramDetailViewModel {
    
    private var router: ProgramDetailRouter!
    
    // MARK: - Init
    init(withRouter router: ProgramDetailRouter) {
        self.router = router
    }
    
    // MARK: - Public methods
    // MARK: - Navigation
    func invest() {
        router.show(routeType: .invest)
    }
}


