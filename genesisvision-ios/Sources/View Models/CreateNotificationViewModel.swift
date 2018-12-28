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
    
    public private(set) var selectedTypeIndex: Int = 0 {
        didSet {
            selectedType = selectedTypeIndex == 0 ? .profit : .level
        }
    }
    
    var typeValues: [String] = [NotificationsAPI.ConditionType_v10NotificationsSettingsAddPost.profit.rawValue, NotificationsAPI.ConditionType_v10NotificationsSettingsAddPost.level.rawValue]
    
    var assetId: String?
    var managerId: String?
    
    private var conditionAmount: Double = 0.0
    
    var selectedLevel: Int = 1
    var enteredProfitValue: Double = 0.0
    
    public private(set) var selectedType: NotificationsAPI.ConditionType_v10NotificationsSettingsAddPost = .profit
    
    private var router: Router!
    private weak var reloadDataProtocol: ReloadDataProtocol?
    
    // MARK: - Init
    init(withRouter router: Router, reloadDataProtocol: ReloadDataProtocol?, assetId: String?, managerId: String? = nil) {
        self.router = router
        self.reloadDataProtocol = reloadDataProtocol
        self.assetId = assetId
        self.managerId = managerId
    }
    
    // MARK: - Public methods
    func createNotification(completion: @escaping CompletionBlock) {
        conditionAmount = selectedType == .profit ? enteredProfitValue : Double(selectedLevel)
        
        NotificationsDataProvider.addSetting(assetId: assetId, managerId: managerId, type: NotificationsAPI.ModelType_v10NotificationsSettingsAddPost.programCondition, conditionType: selectedType, conditionAmount: conditionAmount, completion: { [weak self] (uuidString) in
            self?.router.popViewController(animated: true)
            self?.reloadDataProtocol?.didReloadData()
            completion(.success)
        }, errorCompletion: completion)
    }
    
    func updateSelectedTypeIndex(_ selectedTypeIndex: Int) {
        self.selectedTypeIndex = selectedTypeIndex
    }
}
