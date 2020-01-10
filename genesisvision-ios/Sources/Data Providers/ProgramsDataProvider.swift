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
    static func get(_ filterModel: FilterModel? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (_ programsViewModel: ItemsViewModelProgramDetailsListItem?) -> Void, errorCompletion: @escaping CompletionBlock) {
    
        let levelMin = filterModel?.levelModel.minLevel
        let levelMax = filterModel?.levelModel.maxLevel
        let levelsSet = filterModel?.levelsSet
        
        let tags = filterModel?.tagsModel.selectedTags
        
        let dateFrom = filterModel?.dateRangeModel.dateFrom
        let dateTo = filterModel?.dateRangeModel.dateTo
        
        var sorting: ProgramsAPI.Sorting_getPrograms?
        
        if let selectedSorting = filterModel?.sortingModel.selectedSorting as? ProgramsAPI.Sorting_getPrograms, filterModel?.facetTitle != "Rating" {
            sorting = selectedSorting
        }
        
        if let facetSorting = filterModel?.facetSorting, filterModel?.facetTitle != "Rating" {
            sorting = ProgramsAPI.Sorting_getPrograms(rawValue: facetSorting)
        }
        
        let mask = filterModel?.mask
        let showFavorites = filterModel?.isFavorite
        
        let facetId = filterModel?.facetId
        var ownerId: UUID?
        if let managerId = filterModel?.managerId {
            ownerId = UUID(uuidString: managerId)
        }
        
        let chartPointsCount = filterModel?.chartPointsCount
        
        var programCurrency: ProgramsAPI.ProgramCurrency_getPrograms?
        if let selectedCurrency = filterModel?.currencyModel.selectedCurrency, let newCurrency = ProgramsAPI.ProgramCurrency_getPrograms(rawValue: selectedCurrency) {
            programCurrency = newCurrency
        }
        
        var showIn: ProgramsAPI.ShowIn_getPrograms?
        if let newCurrency = ProgramsAPI.ShowIn_getPrograms(rawValue: selectedPlatformCurrency) {
            showIn = newCurrency
        }
        
        let authorization = AuthManager.authorizedToken
        ProgramsAPI.getPrograms(authorization: authorization,
                                sorting: sorting,
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
        let authorization = AuthManager.authorizedToken
        ProgramsAPI.getProgramDetails(id: assetId, authorization: authorization) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    // MARK: - Invest & Withdraw
    static func getWithdrawInfo(_ assetId: String, completion: @escaping (_ programWithdrawInfo: ProgramWithdrawInfo?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken,
            let uuid = UUID(uuidString: assetId)
            else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        InvestmentsAPI.getProgramWithdrawInfo(id: uuid, authorization: authorization) { (programWithdrawInfo, error) in
            DataProvider().responseHandler(programWithdrawInfo, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    static func withdraw(withAmount amount: Double, assetId: String?, withdrawAll: Bool? = nil, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken,
            let assetId = assetId,
            let uuid = UUID(uuidString: assetId)
            else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        InvestmentsAPI.withdrawFromProgram(id: uuid, authorization: authorization, amount: amount, withdrawAll: withdrawAll) { (error) in
            DataProvider().responseHandler(error, completion: errorCompletion)
        }
    }
    static func invest(withAmount amount: Double, assetId: String?, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken,
            let assetId = assetId,
            let uuid = UUID(uuidString: assetId)
            else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        InvestmentsAPI.investIntoProgram(id: uuid, authorization: authorization, amount: amount) { (error) in
            DataProvider().responseHandler(error, completion: errorCompletion)
        }
    }
    static func reinvestOn(with assetId: String, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken,
            let uuid = UUID(uuidString: assetId) else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        InvestmentsAPI.switchReinvestOn(id: uuid, authorization: authorization) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    static func reinvestOff(with assetId: String, completion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken,
            let uuid = UUID(uuidString: assetId) else { return completion(.failure(errorType: .apiError(message: nil))) }

        InvestmentsAPI.switchReinvestOff(id: uuid, authorization: authorization) { (error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    // MARK: - Trades
    static func getTradesOpen(with assetId: String?, sorting: ProgramsAPI.Sorting_getProgramOpenTrades? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (_ tradesViewModel: TradesViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let assetId = assetId, let uuid = UUID(uuidString: assetId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        ProgramsAPI.getProgramOpenTrades(id: uuid, sorting: sorting, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getTrades(with assetId: String?, dateFrom: Date? = nil, dateTo: Date? = nil, symbol: String? = nil, sorting: ProgramsAPI.Sorting_getAssetTrades? = nil, accountId: UUID? = nil, accountCurrency: ProgramsAPI.AccountCurrency_getAssetTrades? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (_ tradesViewModel: TradesSignalViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let assetId = assetId, let uuid = UUID(uuidString: assetId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
         
        ProgramsAPI.getAssetTrades(id: uuid, dateFrom: dateFrom, dateTo: dateTo, symbol: symbol, sorting: sorting, accountId: accountId, accountCurrency: accountCurrency, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func exportTrades(with assetId: String?, dateFrom: Date? = nil, dateTo: Date? = nil, symbol: String?, sorting: ProgramsAPI.Sorting_exportProgramTrades?, accountId: UUID?, accountCurrency: ProgramsAPI.AccountCurrency_exportProgramTrades?, skip: Int? = nil, take: Int? = nil, completion: @escaping (Data?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let assetId = assetId, let uuid = UUID(uuidString: assetId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        ProgramsAPI.exportProgramTrades(id: uuid, dateFrom: dateFrom, dateTo: dateTo, symbol: symbol, sorting: sorting, accountId: accountId, accountCurrency: accountCurrency, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    

    // MARK: - Periods
    static func getPeriodHistory(with assetId: String?, dateFrom: Date? = nil, dateTo: Date? = nil, numberMin: Int? = nil, numberMax: Int? = nil, status: ProgramsAPI.Status_getProgramPeriods? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (_ programPeriodsViewModel: ProgramPeriodsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let assetId = assetId, let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        ProgramsAPI.getProgramPeriods(id: assetId, authorization: authorization, dateFrom: dateFrom, dateTo: dateTo, numberMin: numberMin, numberMax: numberMax, status: status, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func exportPeriods(with assetId: String, dateFrom: Date? = nil, dateTo: Date? = nil, numberMin: Int?, numberMax: Int?, status: ProgramsAPI.Status_exportProgramPeriods? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (Data?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        ProgramsAPI.exportProgramPeriods(id: assetId, dateFrom: dateFrom, dateTo: dateTo, numberMin: numberMin, numberMax: numberMax, status: status, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    
    static func exportPeriodsFinStatistic(with assetId: String, dateFrom: Date? = nil, dateTo: Date? = nil, numberMin: Int?, numberMax: Int?, status: ProgramsAPI.Status_exportProgramPeriodsFinStatistic? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (Data?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        ProgramsAPI.exportProgramPeriodsFinStatistic(id: assetId, authorization: authorization, dateFrom: dateFrom, dateTo: dateTo, numberMin: numberMin, numberMax: numberMax, status: status, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    // MARK: - Subscribers
    static func getSubscribers(with assetId: String?, dateFrom: Date? = nil, dateTo: Date? = nil, status: ProgramsAPI.Status_getProgramSubscribers? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (SignalProviderSubscribers?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        guard let assetId = assetId, let uuid = UUID(uuidString: assetId), let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        ProgramsAPI.getProgramSubscribers(id: uuid, authorization: authorization, status: status, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    // MARK: - Requests
    static func getRequests(with assetId: String, skip: Int, take: Int, completion: @escaping (ItemsViewModelAssetInvestmentRequest?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let authorization = AuthManager.authorizedToken,
            let uuid = UUID(uuidString: assetId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        InvestmentsAPI.getRequestsByProgram(id: uuid, skip: skip, take: take, authorization: authorization) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    
    // MARK: - Charts
    static func getProfitPercentCharts(with assetId: String, dateFrom: Date? = nil, dateTo: Date? = nil, maxPointCount: Int? = nil, completion: @escaping (_ data: ProgramProfitPercentCharts?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let uuid = UUID(uuidString: assetId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        ProgramsAPI.getProgramProfitPercentCharts(id: uuid, dateFrom: dateFrom, dateTo: dateTo, maxPointCount: maxPointCount) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    static func getBalanceChart(with assetId: String, dateFrom: Date? = nil, dateTo: Date? = nil, maxPointCount: Int? = nil, completion: @escaping (_ data: ProgramBalanceChart?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let uuid = UUID(uuidString: assetId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        ProgramsAPI.getProgramBalanceChart(id: uuid, dateFrom: dateFrom, dateTo: dateTo, maxPointCount: maxPointCount) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    static func getAbsoluteProfitChart(with assetId: String, dateFrom: Date? = nil, dateTo: Date? = nil, maxPointCount: Int? = nil, completion: @escaping (_ data: AbsoluteProfitChart?) -> Void, errorCompletion: @escaping CompletionBlock) {
        guard let uuid = UUID(uuidString: assetId) else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        ProgramsAPI.getProgramAbsoluteProfitChart(id: uuid, dateFrom: dateFrom, dateTo: dateTo, maxPointCount: maxPointCount) { (viewModel, error) in
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
        
        ProgramsAPI.addToFavorites(id: uuid, authorization: authorization) { (error) in
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
        
        ProgramsAPI.removeFromFavorites(id: uuid, authorization: authorization) { (error) in
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

