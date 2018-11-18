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
    var dateFrom: Date?
    var dateTo: Date?
}

struct FilterCurrencyModel {
    var selectedIndex: Int = 0
    var selectedCurrency: String?
}

class FilterModel {
    var sortingModel: FilterSortingModel
    var levelModel: FilterLevelModel
    var dateRangeModel: FilterDateRangeModel
    var currencyModel: FilterCurrencyModel
    
    var chartPointsCount: Int = Api.equityChartLength
    var mask: String?
    var isFavorite: Bool = false
    
    init() {
        sortingModel = FilterSortingModel()
        levelModel = FilterLevelModel()
        dateRangeModel = FilterDateRangeModel()
        currencyModel = FilterCurrencyModel()
    }
}
