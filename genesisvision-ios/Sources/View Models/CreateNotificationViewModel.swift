//
//  CreateNotificationViewModel.swift
//  genesisvision-ios
//
//  Created by George on 26/12/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

final class CreateNotificationViewModel {
    // MARK: - Variables
    var title: String = "Create notifications"
    var labelPlaceholder: String = "0"
    
    var selectedProfit: Double?
    var selectedLevel: Int?
    
    private var router: Router!
    
    // MARK: - Init
    init(withRouter router: Router) {
        self.router = router
    }
    
    // MARK: - Public methods
    func createNotification() {
        //TODO:
    }
    
    // MARK: - Picker View Values
    func typeValues() -> [String] {
        return ["Level", "Profit"]
    }
    
}
