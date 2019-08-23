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
    var sortType: String?
    
    init() {
        highToLowValue = true
        selectedIndex = 0
    }
}

struct FilterTagsModel {
    var selectedIdxs: [Int] = []
    var selectedTags: [String] = []
    
    init() {
        selectedIdxs = []
        selectedTags = []
    }
}

struct FilterLevelModel {
    var minLevel: Int = 1
    var maxLevel: Int = 7
}

struct FilterDateRangeModel {
    var dateRangeType: DateRangeType = .month
    var dateFrom: Date? = Date().removeMonths(1)
    var dateTo: Date? = Date()
}

struct FilterCurrencyModel {
    var selectedIndex: Int = 0
    var selectedCurrency: String?
}

class FilterModel {
    var levelUpSummary: LevelUpSummary?
    
    var sortingModel: FilterSortingModel
    var tagsModel: FilterTagsModel
    var levelModel: FilterLevelModel
    var dateRangeModel: FilterDateRangeModel
    var currencyModel: FilterCurrencyModel
    var chartPointsCount: Int = ApiKeys.equityChartLength
    var mask: String?
    var isFavorite: Bool = false
    var facetId: String?
    var facetTitle: String?
    var facetSorting: String?
    
    var managerId: String?
    
    var profitAvgMin: Double?
    var profitAvgMax: Double?
    
    var onlyActive: Bool = true
    
    var levelsSet: [Int]?
    
    init() {
        sortingModel = FilterSortingModel()
        tagsModel = FilterTagsModel()
        levelModel = FilterLevelModel()
        dateRangeModel = FilterDateRangeModel()
        currencyModel = FilterCurrencyModel()
    }
}
