//
//  ReferralProgramViewController.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 28.10.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import UIKit
import Tabman

class ReferralProgramViewController: BaseTabmanViewController<ReferralProgramViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setup()
    }
    
    private func setup() {
        navigationItem.title = viewModel.title
        dataSource = viewModel.dataSource
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateReferralProgramViewController), name: .updateReferralProgramViewController, object: nil)
    }
    
    @objc private func updateReferralProgramViewController(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        if let historyBadgeValue = userInfo["ReferralHistoryBadgeValue"] as? String {
            bar.items?[2].badgeValue = historyBadgeValue
        } else if let friendsBadgeValue = userInfo["ReferralFriendsBadgeValue"] as? String {
            bar.items?[1].badgeValue = friendsBadgeValue
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .updateReferralProgramViewController, object: nil)
    }
}
