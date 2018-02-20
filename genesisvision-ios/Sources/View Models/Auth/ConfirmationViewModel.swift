//
//  ConfirmationViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

final class ConfirmationViewModel {
    
    // MARK: - Variables
    var title: String = "Confirmation"
    
    private var router: ConfirmationRouter!
    
    // MARK: - Init
    init(withRouter router: ConfirmationRouter) {
        self.router = router
    }
    
    // MARK: - Public methods
    // MARK: - Navigation
    func confirmationButtonAction() {
        router.show(routeType: .popToTraderList)
    }
}
