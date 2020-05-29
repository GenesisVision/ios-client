//
//  ProgramsDataProvider.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 28.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class ProgramsDataProvider: DataProvider {
    // MARK: - Assets
    static func get(_ filterModel: FilterModel? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (_ programsViewModel: ProgramDetailsListItemItemsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
    
        let levelMin = filterModel?.levelModel.minLevel
        let levelMax = filterModel?.levelModel.maxLevel
        let levelsSet = filterModel?.levelsSet
        
        let tags = filterModel?.tagsModel.selectedTags
        
        let dateFrom = filterModel?.dateRangeModel.dateFrom
        let dateTo = filterModel?.dateRangeModel.dateTo
        
        var sorting: ProgramsFilterSorting?
        
        if let selectedSorting = filterModel?.sortingModel.selectedSorting as? ProgramsFilterSorting, filterModel?.facetTitle != "Rating" {
            sorting = selectedSorting
        }
        
        if let facetSorting = filterModel?.facetSorting, filterModel?.facetTitle != "Rating" {
            sorting = ProgramsFilterSorting(rawValue: facetSorting)
        }
        
        let mask = filterModel?.mask
        let showFavorites = filterModel?.isFavorite
        
        let facetId = filterModel?.facetId
        var ownerId: UUID?
        if let managerId = filterModel?.managerId {
            ownerId = UUID(uuidString: managerId)
        }
        
        let chartPointsCount = filterModel?.chartPointsCount
        
        var programCurrency: Currency?
        if let selectedCurrency = filterModel?.currencyModel.selectedCurrency, let newCurrency = Currency(rawValue: selectedCurrency) {
            programCurrency = newCurrency
        }
        
        var showIn: Currency?
        if let newCurrency = Currency(rawValue: selectedPlatformCurrency) {
            showIn = newCurrency
        }
        
        ProgramsAPI.getPrograms(sorting: sorting,
                                showIn: showIn,
                                tags: tags,
                                programCurrency: programCurrency,
                                levelMin: levelMin,
                                levelMax: levelMax,
                                levelsSet: levelsSet,
                                dateFrom: dateFrom,
                                dateTo: dateTo,
                                chartPointsCount: chartPointsCount,
                                facetId: facetId,
                                mask: mask,
                                ownerId: ownerId,
                                showFavorites: showFavorites,
                                skip: skip,
                                take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    static func get(_ assetId: String, completion: @escaping (_ program: ProgramFollowDetailsFull?) -> Void, errorCompletion: @escaping CompletionBlock) {
        ProgramsAPI.getProgramDetails(_id: assetId) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    // MARK: - Invest & Withdraw
    static func getWithdrawInfo(_ assetId: String, completion: @escaping (_ programWithdrawInfo: ProgramWithdrawInfo?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let uuid = UUID(uuidString: assetId)
            else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        InvestmentsAPI.getProgramWithdrawInfo(_id: uuid) { (programWithdrawInfo, error) in
            DataProvider().responseHandler(programWithdrawInfo, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    static func withdraw(withAmount amount: Double, assetId: String?, withdrawAll: Bool? = nil, errorCompletion: @escaping CompletionBlock) {
        guard let assetId = assetId,
            let uuid = UUID(uuidString: assetId)
            else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        InvestmentsAPI.withdrawFromProgram(_id: uuid, amount: amount, withdrawAll: withdrawAll) { (_, error) in
            DataProvider().responseHandler(error, completion: errorCompletion)
        }
    }
    static func invest(withAmount amount: Double, assetId: String?, errorCompletion: @escaping CompletionBlock) {
        guard let assetId = assetId,
            let uuid = UUID(uuidString: assetId)
            else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        InvestmentsAPI.investIntoProgram(_id: uuid, amount: amount) { (_, error) in
            DataProvider().responseHandler(error, completion: errorCompletion)
        }
    }
    static func reinvestOn(with assetId: String, completion: @escaping CompletionBlock) {
        guard let uuid = UUID(uuidString: assetId) else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        InvestmentsAPI.switchReinvestOn(_id: uuid) { (_, error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    static func reinvestOff(with assetId: String, completion: @escaping CompletionBlock) {
        guard let uuid = UUID(uuidString: assetId) else { return completion(.failure(errorType: .apiError(message: nil))) }

        InvestmentsAPI.switchReinvestOff(_id: uuid) { (_, error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    // MARK: - Trades
    static func getTradesOpen(with assetId: String?, sorting: TradeSorting? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (_ tradesViewModel: TradesViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let assetId = assetId, let uuid = UUID(uuidString: assetId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        ProgramsAPI.getProgramOpenTrades(_id: uuid, sorting: sorting, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getTrades(with assetId: String?, dateFrom: Date? = nil, dateTo: Date? = nil, symbol: String? = nil, sorting: TradeSorting? = nil, accountId: UUID? = nil, accountCurrency: Currency? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (_ tradesViewModel: TradesSignalViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let assetId = assetId, let uuid = UUID(uuidString: assetId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
                     
        ProgramsAPI.getAssetTrades(_id: uuid, dateFrom: dateFrom, dateTo: dateTo, symbol: symbol, sorting: sorting, accountId: accountId, accountCurrency: accountCurrency, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func exportTrades(with assetId: String?, dateFrom: Date? = nil, dateTo: Date? = nil, symbol: String?, sorting: TradeSorting?, accountId: UUID?, accountCurrency: Currency? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (Data?) -> Void, errorCompletion: @escaping CompletionBlock) {
                
        guard let assetId = assetId, let uuid = UUID(uuidString: assetId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        ProgramsAPI.exportProgramTrades(_id: uuid, dateFrom: dateFrom, dateTo: dateTo, symbol: symbol, sorting: sorting, accountId: accountId, accountCurrency: accountCurrency, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    

    // MARK: - Periods
    static func getPeriodHistory(with assetId: String?, dateFrom: Date? = nil, dateTo: Date? = nil, numberMin: Int? = nil, numberMax: Int? = nil, status: PeriodStatus? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (_ programPeriodsViewModel: ProgramPeriodsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let assetId = assetId else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        ProgramsAPI.getProgramPeriods(_id: assetId, dateFrom: dateFrom, dateTo: dateTo, numberMin: numberMin, numberMax: numberMax, status: status, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func exportPeriods(with assetId: String, dateFrom: Date? = nil, dateTo: Date? = nil, numberMin: Int?, numberMax: Int?, status: PeriodStatus? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (Data?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        ProgramsAPI.exportProgramPeriods(_id: assetId, dateFrom: dateFrom, dateTo: dateTo, numberMin: numberMin, numberMax: numberMax, status: status, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    
    static func exportPeriodsFinStatistic(with assetId: String, dateFrom: Date? = nil, dateTo: Date? = nil, numberMin: Int?, numberMax: Int?, status: PeriodStatus? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (Data?) -> Void, errorCompletion: @escaping CompletionBlock) {
                
        ProgramsAPI.exportProgramPeriodsFinStatistic(_id: assetId, dateFrom: dateFrom, dateTo: dateTo, numberMin: numberMin, numberMax: numberMax, status: status, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    // MARK: - Subscribers
    static func getSubscribers(with assetId: String?, dateFrom: Date? = nil, dateTo: Date? = nil, status: DashboardActionStatus? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (SignalProviderSubscribers?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let assetId = assetId, let uuid = UUID(uuidString: assetId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        ProgramsAPI.getProgramSubscribers(_id: uuid, status: status, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    // MARK: - Requests
    static func getRequests(with assetId: String, skip: Int, take: Int, completion: @escaping (AssetInvestmentRequestItemsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let uuid = UUID(uuidString: assetId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        InvestmentsAPI.getRequestsByProgram(_id: uuid, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    
    // MARK: - Charts
    static func getProfitPercentCharts(with assetId: String, dateFrom: Date? = nil, dateTo: Date? = nil, maxPointCount: Int? = nil, currency: Currency, currencies: [Currency]?, completion: @escaping (_ data: ProgramProfitPercentCharts?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let uuid = UUID(uuidString: assetId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        ProgramsAPI.getProgramProfitPercentCharts(_id: uuid, dateFrom: dateFrom, dateTo: dateTo, maxPointCount: maxPointCount, currency: currency, currencies: currencies) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    static func getBalanceChart(with assetId: String, dateFrom: Date? = nil, dateTo: Date? = nil, maxPointCount: Int? = nil, currency: Currency, completion: @escaping (_ data: ProgramBalanceChart?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let uuid = UUID(uuidString: assetId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        ProgramsAPI.getProgramBalanceChart(_id: uuid, dateFrom: dateFrom, dateTo: dateTo, maxPointCount: maxPointCount, currency: currency) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    static func getAbsoluteProfitChart(with assetId: String, dateFrom: Date? = nil, dateTo: Date? = nil, maxPointCount: Int? = nil, currency: Currency, completion: @escaping (_ data: AbsoluteProfitChart?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let uuid = UUID(uuidString: assetId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        ProgramsAPI.getProgramAbsoluteProfitChart(_id: uuid, dateFrom: dateFrom, dateTo: dateTo, maxPointCount: maxPointCount, currency: currency) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    // MARK: - Favorites
    static func favorites(isFavorite: Bool, assetId: String, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        isFavorite
            ? favoritesRemove(with: assetId, authorization: authorization, completion: completion)
            : favoritesAdd(with: assetId, authorization: authorization, completion: completion)
    }
    private static func favoritesAdd(with assetId: String, authorization: String, completion: @escaping CompletionBlock) {
        guard let uuid = UUID(uuidString: assetId) else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        ProgramsAPI.addToFavorites(_id: uuid) { (_, error) in
            DataProvider().responseHandler(error, completion: { (result) in
                switch result {
                case .success:
                    NotificationCenter.default.post(name: .programFavoriteStateChange, object: nil, userInfo: ["isFavorite" : true, "programId" : assetId])
                default:
                    break
                }
                
                completion(result)
            })
        }
    }
    private static func favoritesRemove(with assetId: String, authorization: String, completion: @escaping CompletionBlock) {
        guard let uuid = UUID(uuidString: assetId) else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        ProgramsAPI.removeFromFavorites(_id: uuid) { (_, error) in
            DataProvider().responseHandler(error, completion: { (result) in
                switch result {
                case .success:
                    NotificationCenter.default.post(name: .programFavoriteStateChange, object: nil, userInfo: ["isFavorite" : false, "programId" : assetId])
                default:
                    break
                }
                
                completion(result)
            })
        }
    }
}

