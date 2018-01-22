//
//  RealmController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 18.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import RealmSwift

var mainRealm: Realm!

class RealmController {
    
    static var shared: RealmController = RealmController()
    
    func setup() {
        do {
            mainRealm = try Realm()
        } catch let error as NSError {
            NotificationCenter.default.post(name: .RealmLoadingErrorNotifications,
                                            object: nil)
            assertionFailure("Realm loading error: \(error)")
        }
    }
}
