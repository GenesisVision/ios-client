//
//  FilterModel.swift
//  genesisvision-ios
//
//  Created by George on 19/11/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

struct FilterSortingModel {
    var highToLowValue: Bool = true
    var selectedIndex: Int = 0
    var selectedSorting: Any?
    
    init() {
        highToLowValue = true
        selectedIndex = 0
    }
}

struct FilterLevelModel {
    var minLevel: Int = 1
    var maxLevel: Int = 7
}

struct FilterDateRangeModel {
    var dateRangeType: DateRangeType = .week
    var dateFrom: Date? = Date().removeDays(7)
    var dateTo: Date? = Date()
}

struct FilterCurrencyModel {
    var selectedIndex: Int = 0
    var selectedCurrency: String?
}

class FilterModel {
    var levelUpSummary: LevelUpSummary?
    
    var levelUpData: LevelUpData?
    
    var sortingModel: FilterSortingModel
    var levelModel: FilterLevelModel
    var dateRangeModel: FilterDateRangeModel
    var currencyModel: FilterCurrencyModel
    var chartPointsCount: Int = ApiKeys.equityChartLength
    var mask: String?
    var isFavorite: Bool = false
    var facetId: String?
    var facetTitle: String?
    
    var managerId: String?
    
    var profitAvgMin: Double?
    var profitAvgMax: Double?
    
    init() {
        sortingModel = FilterSortingModel()
        levelModel = FilterLevelModel()
        dateRangeModel = FilterDateRangeModel()
        currencyModel = FilterCurrencyModel()
    }
}
