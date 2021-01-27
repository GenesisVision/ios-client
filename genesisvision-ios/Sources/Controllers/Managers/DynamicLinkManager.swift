//
//  DynamicLinkManager.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 25.01.2021.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit

protocol LinkManager {
    func parseLinkFromNotification(notification: [AnyHashable : Any]) -> DynamicLinkType?
}

enum DynamicLinkType {
    case security3fa(code: String, email: String)
}

final class DynamicLinkManager: LinkManager {
    static let shared = DynamicLinkManager()
    private let security3faKey = "security-verification"

    private init() { }
    
    func parseLinkFromNotification(notification: [AnyHashable : Any]) -> DynamicLinkType? {
        guard let url = notification["URL"] as? URL else { return nil }
        
        if let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems,
           let securityCode = queryItems.filter( {$0.name == "code"} ).first?.value,
           let email = queryItems.filter({ $0.name == "email" }).first?.value {
            return .security3fa(code: securityCode, email: email)
        } else {
            return nil
        }
    }
}
