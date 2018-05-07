//
//  ProgramsViewModel.swift
//  genesisvision-ios
//
//  Created by George on 07/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

final class ProgramsViewModel {
    // MARK: - Variables
    var router: Router!
    
    // MARK: - Init
    init(withRouter router: Router) {
        self.router = router
    }
    
    // MARK: - Public methods
    var title: String {
        return ""
    }
    
    var subtitle: String? {
        return ""
    }
}

