//
//  LoginProcessController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 18.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIApplication

class LoginProcessController {
    
    static func setCurrentUser(_ user: UserPlainObject) {
        realmWrite {
            let currentUser: UserEntity = UserEntity()

            currentUser.remoteId = user.id
            currentUser.userName = user.userName
            currentUser.lastName = user.lastName
            currentUser.firstName = user.firstName
            currentUser.photoURL = user.photoUrl ?? ""
            currentUser.token = user.token ?? ""
            currentUser.email = user.email ?? ""
            currentUser.phoneNumber = user.phoneNumber
            currentUser.statusValue = user.status
        }
    }
    
    static var isLogin: Bool {
        return UserDefaults.standard.bool(forKey: Constants.UserDefaults.authorized)
    }
    
    static func login() {
        UserDefaults.standard.set(true, forKey: Constants.UserDefaults.authorized)
        
        guard let viewController = BaseTabBarController.storyboardInstance(name: .main) else { return }
        let window = UIApplication.shared.windows[0] as UIWindow
        window.rootViewController = viewController
    }
    
    static func logout() {
        UserDefaults.standard.set(false, forKey: Constants.UserDefaults.authorized)
        
        guard let viewController = TraderListViewController.storyboardInstance(name: .traders) else { return }
        let window = UIApplication.shared.windows[0] as UIWindow
        let navigationController = BaseNavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
    }
}
