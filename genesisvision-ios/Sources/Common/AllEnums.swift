//
//  AllEnums.swift
//  genesisvision-ios
//
//  Created by George on 17/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

enum CellActionType {
    case none
    case dashboardNotifications
    case dashboardTrading
    case dashboardInvesting
    case dashboardRecommendation
    
    case tradingEvents
    case tradingPublicList
    case tradingPrivateList
    
    case investingEvents
    case investingRequests
    case investingFunds
    case investingPrograms
    
    case createFund
    case createAccount
    
    case attachAccount
    case makeProgram
    case makeSignal
    
    case changePassword
    case closePeriod
    case openSettings
}

enum DidSelectType {
    case none
    case walletFrom
    
    case tradingAccountType
    case accountType
    case leverage
    case currency
    case exchange
    
    case periods
    case tradesDelay
    
    case selectBroker
    case showBrokerDetails
}

enum ActionType {
    case showAll
    case add
    case showBrokerDetails
    case updateNotificationsCount
}

// MARK: - Charts
enum ChartType {
    case `default`, detail, full, dashboard, balance, profit
}

enum ChartDurationType: Int {
    case day, week, month, month3, month6, year, all
    
    var allCases: [String] {
        return ["1d", "1w", "1m", "3m", "6m", "1y", "all"]
    }
}

// MARK: - DateRange
enum DateRangeType: Int {
    case day
    case week
    case month
    case year
    case all
    case custom
    
    func getString() -> String {
        switch self {
        case .day:
            return "Last day"
        case .week:
            return "Last week"
        case .month:
            return "Last month"
        case .year:
            return "Last year"
        case .all:
            return "All time"
        case .custom:
            return "Custom"
        }
    }
    
    func getButtonTitle() -> String {
        switch self {
        case .day:
            return "Day"
        case .week:
            return "Week"
        case .month:
            return "Month"
        case .year:
            return "Year"
        case .all:
            return "All time"
        case .custom:
            return "Custom"
        }
    }
}

// MARK: - Currency
typealias CurrencyType = Currency
typealias SortingListType = ProgramsFilterSorting

extension CurrencyType {
    public var currencyLenght: Int {
        switch self {
        case .gvt: return 4
        case .eth, .btc: return 8
        case .usd, .eur, .usdt: return 2
        case .undefined: return 2 //for percent
        default:
            return 4
        }
    }
    
    public var currencyColor: UIColor {
        switch self {
        case .gvt: return UIColor.Currency.gvt
        case .eth: return UIColor.Currency.eth
        case .btc: return UIColor.Currency.btc
        case .ada: return UIColor.Currency.btc
        case .usd: return UIColor.Currency.usd
        case .usdt: return UIColor.Currency.usd
        case .eur: return UIColor.Currency.eur
        default:
            return UIColor.Currency.gvt
        }
    }
}

// MARK: - Data
enum DataType {
    case api
    case fake
}

enum WalletTransferType {
    case fromWallet
    case fromAccount
}

enum WalletBalanceType: String {
    case total = "Total balance"
    case available = "Available"
    case invested = "Invested"
    case trading = "Trading"
}

enum WalletType {
    case all
    case wallet
}

// MARK: - CompletionsResult
enum CompletionResult {
    case success
    case failure(errorType: ErrorMessageType)
}

// MARK: - BottomView
enum BottomViewType {
    case none, signIn, sort, filter, signInWithFilter, dateRange, signInWithDateRange
}

// MARK: - TableViewCell
enum SectionType {
    case facetList, assetList
}

// MARK: - Stroryboard Instances
enum StoryboardNames: String {
    case main
    case program
    case fund
    case manager
    case launch
    case profile
    case settings
    case assets
    case auth
    case wallet
    case dashboard
    case notifications
}

// MARK: - Filters
enum SliderType: Int {
    case level, avgProfit, totalProfit, balance
}

enum SwitchType: Int {
    case activePrograms, favoritePrograms, availableToInvest
}

