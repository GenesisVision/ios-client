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

#if DEBUG
    let isUITest = ProcessInfo.processInfo.environment["UITest"] != nil
#else
    let isUITest = false
#endif

typealias ActionCompletionBlock = () -> Void
typealias CompletionBlock = (_ result: CompletionResult) -> Void
typealias SuccessCompletionBlock = (_ success: Bool) -> Void


final class Constants {
    struct Urls {
        static let feedbackWebAddress = "https://feedback.genesis.vision"
        static let termsWebAddress = "https://genesis.vision/terms.html"
        static let privacyWebAddress = "https://genesis.vision/privacy-policy.html"
        
        
        static let feedbackEmailAddress = "support@genesis.vision"
        static let appStoreAddress = "itms-apps://itunes.apple.com/app/genesis-vision-investor/id1369865290?mt=8"
    }
    
    struct Api {
        static let basePath =
            isTournamentApp
                ? isDebug
                    ? Tournament.debug
                    : Tournament.release
                : isInvestorApp
                    ? isDebug
                        ? Investor.debug
                        : Investor.release
                    : isDebug
                        ? Manager.debug
                        : Manager.release
        
        static let ipfsPath = "https://gateway.ipfs.io/ipfs/"
        
        static let filePath = basePath + "/v1.0/file/"
        
        static let fetchThreshold = 1 // a constant to determine when to fetch the results

        static let take: Int = 50
        static let maxPoint: Int = 100
        static let equityChartLength: Int = 36
        
        struct Investor {
            static let debug = "https://black-api.genesis.vision"
            static let release = "https://alpha.genesis.vision"
        }
        
        struct Manager {
            static let debug = "https://black-api.genesis.vision"
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
        
        static let passcode: String = "passcode"
        static let passcodeEnable: String = "passcodeEnable"
        static let biometricEnable: String = "biometricEnable"
        
        static let biometricLastDomainState: String = "biometricLastDomainState"
        
        static let colorTheme: String = "colorTheme"
        
        static let selectedCurrency: String = "selectedCurrency"
    }
    
    struct Keys {
        static let signOutKey: String = "signOutKey"
        static let twoFactorEnableKey: String = "twoFactorEnableKey"
        
        static let twoFactorChangeKey: String = "twoFactorChangeKey"
        static let programFavoriteStateChangeKey: String = "programFavoriteStateChangeKey"
        static let fundFavoriteStateChangeKey: String = "fundFavoriteStateChangeKey"
        
        static let addedLineLayer: String = "addedLineLayer"
        
        static let themeChangedKey: String = "themeChangedKey"
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
    }
    
    struct Sorting {
        static let programListDefault: ProgramsAPI.Sorting_v10ProgramsGet = .byProfitDesc
        static let dashboardDefault: InvestorAPI.Sorting_v10InvestorProgramsGet = .byProfitDesc
    }
    
    struct Security {
        static let passcodeDigit: Int = 6
        static let timeInterval: Double = isDebug ? 2.0 : 30.0
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
            static let verticalMarginValues: CGFloat = 8.0
        }
        
        static let cornerSize: CGFloat = 16.0
        static var chartCircleHeight: CGFloat = 9.0
        static let selectedSegmentedTitle: CGFloat = 23.0
        static let unselectedSegmentedTitle: CGFloat = 15.0
        
        static let imageViewBorderWidthPercentage: CGFloat = 0.04
    }
    
    static let gvtString = "GVT"
}
