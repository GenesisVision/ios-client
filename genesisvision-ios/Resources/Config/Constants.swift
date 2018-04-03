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

final class Constants {
    
    struct Api {
        static let basePath = isTournamentApp
            ? isDebug ? Tournament.debug : Tournament.release
            : isDebug ? Main.debug : Main.release
        
        static let ipfsPath = "https://gateway.ipfs.io/ipfs/"
        
        static let filePath = basePath + "/api/files?id="
        
        static let fetchThreshold = 1 // a constant to determine when to fetch the results

        static let take = 50 //count of templates on 1 page
        
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
    }
    
    struct Filters {
        static let minLevel: Int = 1
        static let maxLevel: Int = 7
        
        static let minAvgProfit: Int = -100
        static let maxAvgProfit: Int = 1000
        
        static let walletModelTypeDefault: TransactionsFilter.ModelType = .all
    }
    
    struct Sorting {
        static let programListDefault: InvestmentProgramsFilter.Sorting = .byProfitDesc
        static let dashboardDefault: InvestorAPI.Sorting_apiInvestorDashboardGet = .byProfitDesc
    }

    struct TemplatesCounts {
        static let traders: Int = 30
        static let transactions: Int = 30
    }
    
    static let currency = "GVT"
    static let hudDelay: Double = 2.0
    
    struct Profile {
        static let minYear: Int = 0
    }
    struct SystemSizes {
        static let imageViewBorderWidthPercentage: CGFloat = 0.04
    }
    
    struct Keys {
        static let signOutKey: String = "signOutKey"
        
        static let addedLineLayer: String = "addedLineLayer"
    }
    
    struct ErrorMessages {
        static let noInternetConnection = "No Internet Connection"
        static let noDataText = "not enough data\n for the chart"
    }
    
    struct Titles {
        static let refreshControlTitle = "Loading..."
    }
}
