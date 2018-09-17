//
//  Enums.swift
//  genesisvision-ios
//
//  Created by George on 17/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

// MARK: - DateRange
enum DateRangeType: Int {
    case day
    case week
    case month
    case year
    case custom
}

// MARK: - Currency
enum CurrencyType: Int {
    case gvt, btc, eth, ada, usd, eur, percent
    
    public var currencyLenght: Int {
        switch self {
        case .gvt: return 4
        case .btc: return 8
        case .eth: return 8
        case .ada: return 8
        case .usd: return 2
        case .eur: return 2
        case .percent: return 2
        }
    }
}

extension CurrencyType {
    init?(currency: InvestmentProgramDetails.Currency) {
        switch currency {
        case .gvt:
            self.init(rawValue: 0)
        case .btc:
            self.init(rawValue: 1)
        case .eth:
            self.init(rawValue: 2)
        case .ada:
            self.init(rawValue: 3)
        case .usd:
            self.init(rawValue: 4)
        case .eur:
            self.init(rawValue: 5)
        case .undefined:
            self.init(rawValue: 0)
        }
    }
    
    init?(currency: InvestmentProgramDashboardInvestor.Currency) {
        switch currency {
        case .gvt:
            self.init(rawValue: 0)
        case .btc:
            self.init(rawValue: 1)
        case .eth:
            self.init(rawValue: 2)
        case .ada:
            self.init(rawValue: 3)
        case .usd:
            self.init(rawValue: 4)
        case .eur:
            self.init(rawValue: 5)
        case .undefined:
            self.init(rawValue: 0)
        }
    }
    
    init?(currency: String) {
        switch currency.uppercased() {
        case "GVT":
            self.init(rawValue: 0)
        case "BTC":
            self.init(rawValue: 1)
        case "ETH":
            self.init(rawValue: 2)
        case "ADA":
            self.init(rawValue: 3)
        case "USD":
            self.init(rawValue: 4)
        case "EUR":
            self.init(rawValue: 5)
        default:
            self.init(rawValue: 0)
        }
    }
}

// MARK: - Data
enum DataType {
    case api
    case fake
}

// MARK: - CompletionsResult
enum CompletionResult {
    case success
    case failure(errorType: ErrorMessageType)
}

// MARK: - BottomView
enum BottomViewType {
    case none, signIn, sort, filter, sortAndFilter, signInWithSortAndFilter
}

// MARK: - TableViewCell
enum SectionType {
    case header
    case programList
}

// MARK: - Stroryboard Instances
enum StoryboardNames: String {
    case main
    case program
    case launch
    case profile
    case settings
    case programs
    case auth
    case wallet
    case dashboard
    case tournament
}

// MARK: - Filters
enum SliderType: Int {
    case level, avgProfit, totalProfit, balance
}

enum SwitchType: Int {
    case activePrograms, favoritePrograms, availableToInvest
}

