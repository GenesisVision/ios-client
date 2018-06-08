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
    case failure(errorType: ErrorMessageType)
}

typealias ActionCompletionBlock = () -> Void
typealias CompletionBlock = (_ result: CompletionResult) -> Void
typealias SuccessCompletionBlock = (_ success: Bool) -> Void

enum DataType {
    case api
    case fake
}

enum CurrencyType: Int {
    case gvt = 4, crypto = 8, other = 2
}


final class Constants {
    struct Urls {
        static let feedbackWebAddress = "https://feedback.genesis.vision"
        static let feedbackEmailAddress = "support@genesis.vision"
        static let appStoreAddress = "itms-apps://itunes.apple.com/app/genesis-vision-investor/id1369865290?mt=8"
    }
    
    struct Api {
        static let basePath = isTournamentApp
            ? isDebug ? Tournament.debug : Tournament.release
            : isDebug ? Main.debug : Main.release
        
        static let ipfsPath = "https://gateway.ipfs.io/ipfs/"
        
        static let filePath = basePath + "/api/files?id="
        
        static let fetchThreshold = 1 // a constant to determine when to fetch the results

        static let take: Int = 50 //count of templates on 1 page
        static let equityChartLength: Int = 36
        
        struct Main {
            static let debug = "https://alpha.genesis.vision"
            static let release = "https://alpha.genesis.vision"
        }
        
        struct Tournament {
            static let debug = ""
            static let release = ""
        }
    }
    
    struct UserDefaults {
        static let authorizedToken: String = "AuthorizedToken"
        static let timesOpened: String = "TimesOpened"
        static let restrictRotation: String = "RestrictRotation"
        static let skipThisVersion: String = "skipThisVersion"
        static let launchedBefore: String = "launchedBefore"
    }
    
    struct Keys {
        static let signOutKey: String = "signOutKey"
        static let twoFactorEnableKey: String = "twoFactorEnableKey"
        static let twoFactorChangeKey: String = "twoFactorChangeKey"
        
        static let addedLineLayer: String = "addedLineLayer"
    }
    
    struct Filters {
        static let minLevel: Int = 1
        static let maxLevel: Int = 7
        
        static let minAvgProfit: Double = -100.0
        static let maxAvgProfit: Double = 1000.0
        
        static let minTotalProfit: Double = -5000.0
        static let maxTotalProfit: Double = 5000.0
        
        static let minUsdBalance: Double = 0.0
        static let maxUsdBalance: Double = 300000.0
        
        static let showActivePrograms = false
        static let showMyFavorites = false
        static let showAvailableToInvest = false
        
        static let walletModelTypeDefault: TransactionsFilter.ModelType = .all
    }
    
    struct Sorting {
        static let programListDefault: InvestmentProgramsFilter.Sorting = .byProfitDesc
        static let dashboardDefault: InvestorAPI.Sorting_apiInvestorDashboardGet = .byProfitDesc
    }

    struct TemplatesCounts {
        static let traders: Int = 30
        static let transactions: Int = 30
        
        static let timerSeconds: Double = 200.0
    }
    
    static let currency = "GVT"
    
    struct HudDelay {
        static let `default`: Double = 2.0
        static let error: Double = 2.0
        static let success: Double = 1.0
    }
    
    struct Profile {
        static let minYear: Int = 0
    }
    
    struct SystemSizes {
        struct Cell {
            static let horizontalMarginValue: CGFloat = 8.0
            static let verticalMarginValues: CGFloat = 4.0
        }
        
        static let cornerSize: CGFloat = 6.0
        
        static let imageViewBorderWidthPercentage: CGFloat = 0.04
    }
}
