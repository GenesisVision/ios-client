//
//  Constants.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 22.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

#if INVESTOR
    let isInvestorApp = true
#else
    let isInvestorApp = false
#endif

#if TOURNAMENT
    let isTournamentApp = true
#else
    let isTournamentApp = false
#endif

#if DEBUG
    let isDebug = true
#else
    let isDebug = false
#endif

enum CompletionResult {
    case success
    case failure(reason: String?)
}

typealias ActionCompletionBlock = () -> Void
typealias CompletionBlock = (_ result: CompletionResult) -> Void
typealias SuccessCompletionBlock = (_ success: Bool) -> Void

enum DataType {
    case api
    case fake
}

final class Constants {
    
    struct Api {
        static let basePath = isTournamentApp
            ? isDebug ? Tournament.debug : Tournament.release
            : isDebug ? Main.debug : Main.release
        
        static let ipfsPath = "https://gateway.ipfs.io/ipfs/"
        
        static let filePath = basePath + "/api/files?id="
        
        static let fetchThreshold = 20 // a constant to determine when to fetch the results

        static let take = 50 //count of templates on 1 page
        
        struct Main {
            static let debug = "https://localhost"
            static let release = "https://localhost"
        }
        struct Tournament {
            static let debug = "https://localhost"
            static let release = "https://localhost"
        }
    }
    
    struct UserDefaults {
        static let authorizedToken: String = "AuthorizedToken"
        static let timesOpened: String = "TimesOpened"
    }

    struct TemplatesCounts {
        static let traders: Int = 30
        static let transactions: Int = 30
    }
    
    static let currency = "GVT"
    
    struct SystemSizes {
        static let imageViewBorderWidthPercentage: CGFloat = 0.04
    }
    
    struct Keys {
        static let signOutKey: String = "signOutKey"
    }
    
    struct Titles {
        static let refreshControlTitle = "Loading..."
    }
}
