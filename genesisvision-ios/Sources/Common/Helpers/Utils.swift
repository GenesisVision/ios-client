//
//  Utils.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 12.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import AVFoundation

func getFileURL(fileName: String) -> URL? {
    return URL(string: Constants.Api.filePath + fileName)
}

func feedback(style: UIImpactFeedbackStyle = .light) {
    let generator = UIImpactFeedbackGenerator(style: style)
    generator.impactOccurred()
}

func networkActivity(show: Bool = true) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = show
}

func getPeriodLeft(endOfPeriod: Date) -> (String, String) {
    let dateInterval = endOfPeriod.interval(ofComponent: .minute, fromDate: Date())

    return ((dateInterval > 0 ? dateInterval : 0).toString(), "min")
}

var sortingKeys: [InvestmentProgramsFilter.Sorting] = [.byLevelAsc, .byLevelDesc, .byOrdersAsc, .byOrdersDesc, .byProfitAsc, .byProfitDesc, .byEndOfPeriodAsk, .byEndOfPeriodDesc]
var sortingValues: [String] = ["Level ⇡", "Level ⇣", "Orders ⇡", "Orders ⇣", "Profit ⇡", "Profit ⇣", "End of period ⇡", "End of period ⇣"]
struct SortingList {
    var sortingValue: String
    var sortingKey: InvestmentProgramsFilter.Sorting
}
var sortingList: [SortingList] = sortingValues.enumerated().map { (index, element) in
    return SortingList(sortingValue: element, sortingKey: sortingKeys[index])
}

func getSortingValue(sortingKey: InvestmentProgramsFilter.Sorting) -> String {
    guard let index = sortingKeys.index(of: sortingKey) else { return "" }
    return sortingValues[index]
}

