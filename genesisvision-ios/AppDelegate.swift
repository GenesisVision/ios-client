//
//  AppDelegate.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setup()
        return true
    }
}

// MARK: - Setup
extension AppDelegate {
    private func setup() {
        AppearanceController.setupAppearance()
        SwaggerClientAPI.basePath = Constants.Api.basePath
    }
}
