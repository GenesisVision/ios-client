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
typealias CurrencyType = ProgramsAPI.CurrencySecondary_v10ProgramsGet

extension CurrencyType {
    public var currencyLenght: Int {
        switch self {
        case .gvt: return 4
        case .eth, .btc, .ada: return 8
        case .usd, .usdt, .eur: return 2
        case .undefined:
            return 2
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
    case none, signIn, sort, filter, signInWithFilter, dateRange
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

