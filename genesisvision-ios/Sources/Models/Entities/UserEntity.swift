//
//  UserEntity.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 23.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import RealmSwift

class UserEntity: Object, ObjectSingletone {
    @objc dynamic var isLoggedIn: Bool = false
    @objc dynamic var token: String = ""
    
    func updateProfileser(currentProfile: ProfileEntity?) {
        self.currentProfile = currentProfile
    }
    
    @objc private(set) dynamic var currentProfile: ProfileEntity?
}

