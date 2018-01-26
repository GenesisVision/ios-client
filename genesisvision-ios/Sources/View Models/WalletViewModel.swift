//
//  WalletViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

class WalletViewModel {
    
    private var router: WalletRouter!
    
    // MARK: - Init
    init(withRouter router: WalletRouter) {
        self.router = router
    }
    
    // MARK: - Public methods
    func withdraw() {
        router.show(routeType: .withdraw)
    }
}

