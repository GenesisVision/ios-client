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
