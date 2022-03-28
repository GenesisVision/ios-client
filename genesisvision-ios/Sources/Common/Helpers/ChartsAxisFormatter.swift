//
//  ChartsAxisFormatter.swift
//  genesisvision-ios
//
//  Created by Gregory on 28.03.2022.
//  Copyright © 2022 Genesis Vision. All rights reserved.
//

import Foundation
import Charts

class MyXAxisFormatter: NSObject, IAxisValueFormatter {

    var dateFormat: String
    var xVlaues: [Double]

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let xValue = xVlaues[Int(value)]
        let date = Date(timeIntervalSince1970: TimeInterval(xValue) / 1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let dateString = dateFormatter.string(from: date)
        return dateString
    }

    init(dateFormat: String, xVlaues: [Double]) {
        self.dateFormat = dateFormat
        self.xVlaues = xVlaues
    }
}
