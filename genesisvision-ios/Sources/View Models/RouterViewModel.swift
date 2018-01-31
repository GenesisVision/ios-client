//
//  RouterViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 31.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class FilterViewModel {
    
    private var router: FilterRouter!
    
    // MARK: - Init
    init(withRouter router: FilterRouter) {
        self.router = router
    }
    
    // MARK: - Public methods
    // MARK: - Navigation
    func reset() {
        router.show(routeType: .reset)
    }
}



