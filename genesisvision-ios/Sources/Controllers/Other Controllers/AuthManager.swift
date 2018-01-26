//
//  AuthController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 18.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIApplication

class AuthManager {
    
    static func setCurrentProfile(_ profileObject: ProfileObject) {
        realmWrite {
            let currentProfile: ProfileEntity = ProfileEntity()
            
            currentProfile.firstName = profileObject.firstName
            currentProfile.lastName = profileObject.lastName
            currentProfile.middleName = profileObject.middleName
            currentProfile.avatar = profileObject.avatar ?? ""
            currentProfile.email = profileObject.email ?? ""
            currentProfile.phone = profileObject.phone
        }
    }
    
    static var authorizedToken: String? {
        set(newToken) {
            UserDefaults.standard.set(newToken, forKey: Constants.UserDefaults.authorizedToken)
        }
        get {
            guard let token = UserDefaults.standard.string(forKey: Constants.UserDefaults.authorizedToken) else { return nil }
            
            return "Bearer " + token
        }
    }
    
    static func authorizedTokenWithBearer() -> String? {
        guard let token = authorizedToken else { return nil }
        
        return "Bearer " + token
    }
    
    static func isLogin() -> Bool {
        return AuthManager.authorizedToken != nil
    }
}
