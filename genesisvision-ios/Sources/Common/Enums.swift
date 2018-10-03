//
//  Enums.swift
//  genesisvision-ios
//
//  Created by George on 17/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

// MARK: - Charts
enum ChartType {
    case `default`, detail, full
}

enum ChartDurationType: Int {
    case day, week, month, month3, month6, year, all
    
    var allCases: [String] {
        return ["1d", "1w", "1m", "3m", "6m", "1y", "all"]
    }
    
//    func getTimeFrame() -> InvestorAPI.TimeFrame_apiInvestorProgramEquityChartGet {
//        var timeFrame = InvestorAPI.TimeFrame_apiInvestorProgramEquityChartGet.day1
//    
//        switch self {
//        case .day:
//            timeFrame = InvestorAPI.TimeFrame_apiInvestorProgramEquityChartGet.day1
//        case .week:
//            timeFrame = InvestorAPI.TimeFrame_apiInvestorProgramEquityChartGet.week1
//        case .month:
//            timeFrame = InvestorAPI.TimeFrame_apiInvestorProgramEquityChartGet.month1
//        case .month3:
//            timeFrame = InvestorAPI.TimeFrame_apiInvestorProgramEquityChartGet.month3
//        case .month6:
//            timeFrame = InvestorAPI.TimeFrame_apiInvestorProgramEquityChartGet.month6
//        case .year:
//            timeFrame = InvestorAPI.TimeFrame_apiInvestorProgramEquityChartGet.year1
//        case .all:
//            timeFrame = InvestorAPI.TimeFrame_apiInvestorProgramEquityChartGet.all
//        }
//        
//        return timeFrame
//    }
}

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
    init?(currency: ProgramsAPI.CurrencySecondary_v10ProgramsGet) {
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
    
    init?(currency: InvestorAPI.Currency_v10InvestorPortfolioChartGet) {
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
}

// MARK: - Filters
enum SliderType: Int {
    case level, avgProfit, totalProfit, balance
}

enum SwitchType: Int {
    case activePrograms, favoritePrograms, availableToInvest
}

